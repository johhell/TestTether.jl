

using ModelingToolkit
using DifferentialEquations
using LinearAlgebra


include("Tparameters.jl")


@variables t
D = Differential(t)


function Segment(param::Settings, idx::Int64; name)

    @parameters begin
        v_wind[1:3] = param.wind_speed
    end

    @variables begin
        pos(t)[1:3]
        posM(t)[1:3] = param.positionStart[idx]
        velM(t)[1:3] = [0.0,0.0,0.0]
        accM(t)[1:3] = [0.0,0.0,0.0]
        segment(t)[1:3]
        segment_unit(t)[1:3]
        segmentABS(t) = param.len_per_segment
        vRel(t)[1:3]
        vRel_unit(t)[1:3]
        vRelABS(t) = 0.0
        force_spring(t)[1:3]
        force_springABS(t) = 0
        force_external(t)[1:3]
        force_friction(t)[1:3]
        v_seg(t) = 0.0  # elongation
        lgwind(t)
    end

    eqs = []
    eqs = vcat(eqs,  D.(posM) ~ velM)
    eqs = vcat(eqs,  D.(velM) ~ accM)
    eqs = vcat(eqs,  segment ~ posM-pos)
    eqs = vcat(eqs,  segment_unit ~ segment / segmentABS)
    eqs = vcat(eqs,  vRel ~ velM-v_wind)
    eqs = vcat(eqs,  vRelABS ~ max(0.01,norm(vRel)))
    eqs = vcat(eqs,  vRel_unit ~ vRel / vRelABS)
    eqs = vcat(eqs,  lgwind ~ norm(cross(vRel_unit,segment)))
    eqs = vcat(eqs,  force_friction ~ lgwind* vRel_unit * param.frictionCoeff * vRelABS^2)
    eqs = vcat(eqs,  segmentABS ~ norm(segment))
    eqs = vcat(eqs,  v_seg ~ D(segmentABS))
    eqs = vcat(eqs,  force_springABS ~ -(segmentABS-param.len_per_segment)*param.c_spring0 - v_seg*param.damping)
    eqs = vcat(eqs,  force_spring ~ segment_unit * force_springABS)
    eqs = vcat(eqs,  (accM .- param.g_earth)* param.mass_per_seg ~  force_spring + force_external - force_friction)

    ODESystem(eqs, t; name = name)
end



listofSegments = []

function AddNewSegment(idx::Int, segList::Vector, ss::Settings)
    s = Symbol("S", idx)
    @eval ( @named ($s) = Segment($ss,$idx))
    @eval ( push!($segList,($s)))
end


function model(se::Settings)

    # creating segments
    for i = 1:se.segments
        AddNewSegment(i, listofSegments, se)
    end

    # connecting segments
    #TODO   Future: replaced by @connnector???
    function SegmentConnections(listSegs::Vector)
        eqs = []
        eqs = vcat(eqs, listSegs[1].pos .~ [0.0,0.0, 0.0])  # 1st segment with fixed position
        for i = 1:se.segments-1
            eqs = vcat(eqs, listSegs[i+1].pos ~ listSegs[i].posM)   # segments in between
            eqs = vcat(eqs, listSegs[i].force_external ~ - listSegs[i+1].force_spring) # segments in between
        end
        eqs = vcat(eqs, listSegs[end].force_external .~ se.endForce)     # last segment
        eqs
    end

    connectEqu = SegmentConnections(listofSegments)
    @named sys = ODESystem(connectEqu, t, systems=listofSegments)
    return simpsys = structural_simplify(sys)
end





function simulate(se, simple_sys)
    dt = 0.02
    tol = 1e-6
    tspan = (0.0, se.duration)
    ts    = 0:dt:se.duration
    prob = ODEProblem(simple_sys, nothing, tspan)
    @time sol = solve(prob, Rodas5(), dt=dt, abstol=tol, reltol=tol, saveat=ts)
    sol
end


