
using JLD2
using Plots

include("../src/T7modia.jl")


@time RunSim(multiPendulum, se.duration)


N = multiPendulum.statistics[:nResults]
T = multiPendulum.result.t[1]


segments = se.segments

positions = Vector()
for i in 1:segments
    pos = copy(ustrip(get_result(multiPendulum, "m$(i).box.r_abs")))
    push!(positions, pos)
end


xx = positions[segments][:,1]    # last segement
zz = positions[segments][:,3]


jldsave("T7modia.jld2"; T, xx,zz)   # last segments
jldsave("X7modia.jld2"; segments, T, positions) # all segments


plot(xx,zz, aspect_ratio=:equal)


