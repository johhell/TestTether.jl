
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


using HDF5

h5open("T7modia.hdf5", "w") do fid
    fid["zeit"] = T
    fid["model"] = "modia"
    fid["segments"] = se.segments
    gruppe= create_group(fid, "positions")
    for i = 1:se.segments
        xyz = positions[i]
        gruppe["pos$(i)"] = xyz
    end
end




plot(xx,zz, aspect_ratio=:equal)


