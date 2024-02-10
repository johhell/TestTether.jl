

using Modia3D

using Parameters
using JLD2

include("$(Modia3D.modelsPath)/Blocks.jl")
include("$(Modia3D.modelsPath)/Electric.jl")
include("$(Modia3D.modelsPath)/Rotational.jl")


include("./Tparameters.jl")


se = Settings()

# mass_per_meter = se.rho_tether * pi * (se.d_tether/2000.0)^2


# len_per_segment = se.l0 / se.segments
# mass_per_seg = mass_per_meter * len_per_segment

#springForce = se.c_spring/len_per_segment

# revolute DAMPING
Rdamping = 0.0




function thrust(; time, objectApply, objectCoord)
    if time > 1.0
        Modia.SVector{3,Float64}(0.0, 0.0, 0.0)
    else
        Modia.SVector{3,Float64}(0.0, 0.0, 0.0)
    end
end



ElementXX(;obj1, phiY_start=0.0) =  Model(

    box     = Object3D(feature=Solid(massProperties=MassProperties(; mass=se.mass_per_seg, Ixx=0.0, Iyy=0.0, Izz=0.02))),
    frame1  = Object3D(parent=:box, translation=:[ se.len_per_segment, 0.0, 0.0]),
    rev1    = RevoluteWithFlange(obj1=obj1,   obj2=:frame1, axis=2, phi=Var(init=phiY_start)),


    damper1 = Damper | Map(d=Rdamping),
    fixed  = Fixed,
    connect = :[
                (damper1.flange_b, rev1.flange),
                (damper1.flange_a, fixed.flange)
            ]
    )


Kraft(;obj1) =  Model( force = WorldForce(objectApply=obj1, forceFunction=thrust, objectCoord=:world),  )

tetherTest = Model3D(
    world   = Object3D(feature=Scene(gravityField=UniformGravityField(g=9.81, n=[0, 0, -1]) )),
    m1 = ElementXX(obj1=:world, phiY_start=se.α0-pi/2.0),
)


# Kette
for i = 2:se.segments
    tetherTest[Symbol("m$(i)")] = ElementXX(obj1=Meta.parse("m$(i-1).box"), phiY_start=0.0)
    if i==se.segments #last segment
        tetherTest[:force] = Kraft(obj1=Meta.parse("m$(i).box"))
    end
end


multiPendulum = @instantiateModel(tetherTest,
                    unitless=true,
                    log=false,
#                     saveCodeOnFile="CODE.txt.jl",
                    )



function RunSim(model, duration)
    interval = 0.02
    simulate!(model,
        stopTime=duration,
        interval=interval,
        log=false,
        logEvaluatedParameters=false,
        logStates=false,
#           merge = Map(m1=Map(rev1=Map(phi=Var(init=1.0)))),   #FIXME
        )

end


nothing

# @time RunSim(multiPendulum, se.duration)
#
#
#
# N = multiPendulum.statistics[:nResults]
# T = multiPendulum.result.t
#
#
# position = Vector()
# for i in 1:se.segments
#     pos = ustrip(get_result(multiPendulum, "m$(i).box.r_abs"))
#     push!(position, pos)
# end
#
#
# xx = position[se.segments][:,1]
# zz = position[se.segments][:,3]
#
#
# jldsave("T7modia.jld2"; T, xx,zz)
#
#
