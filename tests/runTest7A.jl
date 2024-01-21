
# using JLD2
using Plots

include("../src/Tether_07A.jl")

se = Settings()
# reel-out speed = 0
se.v_ro = 0.0
simple_sys, pos, vel = model(se)
sol = simulate(se, simple_sys)

lastIndex = se.segments+1

# position of the last particle
T = sol.t
# xx = sol(T, idxs=pos[1,lastIndex]).u
# yy = sol(T, idxs=pos[2,lastIndex]).u
# zz = sol(T, idxs=pos[3,lastIndex]).u
#
# jldsave("T7A.jld2"; T, xx,zz)

using HDF5

h5open("T7A.hdf5", "w") do fid
    fid["zeit"] = T
    fid["model"] = "7A-org"
    fid["segments"] = se.segments
    gruppe= create_group(fid, "positions")
    for i = 1:se.segments
        xx = sol(T, idxs=pos[1,i+1]).u
        yy = sol(T, idxs=pos[2,i+1]).u
        zz = sol(T, idxs=pos[3,i+1]).u
        gruppe["pos$(i)"] = hcat(xx,yy,zz)
    end
end





plot(xx,zz, aspect_ratio=:equal)


