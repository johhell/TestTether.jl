
using Plots
using HDF5

include("../src/Tether_07B.jl")
TestCase = "7B"


se = Settings(; v_ro = 0.0)   # reel-out speed = 0
simple_sys, pos, vel = model(se)
sol = simulate(se, simple_sys)

lastIndex = se.segments+1

# position of the last particle
T = sol.t
xx = sol(T, idxs=pos[1,lastIndex]).u
yy = sol(T, idxs=pos[2,lastIndex]).u
zz = sol(T, idxs=pos[3,lastIndex]).u


h5open("T7B.hdf5", "w") do fid
    fid["zeit"] = T
    fid["model"] = TestCase
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
