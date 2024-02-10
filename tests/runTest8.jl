
using Plots
using HDF5

include("../src/Tether_08.jl")
TestCase = "8seg"


se = Settings(; v_ro = 0.0, frictionCoeff = 0.0)

simple_sys = model(se)

sol = simulate(se, simple_sys)



# position of the last particle

lastSeg = listofSegments[end]
T = sol.t
xx = sol(T, idxs=lastSeg.posM[1]).u
yy = sol(T, idxs=lastSeg.posM[2]).u
zz = sol(T, idxs=lastSeg.posM[3]).u



using HDF5

h5open("T8seg.hdf5", "w") do fid
    fid["zeit"] = T
    fid["model"] = TestCase
    fid["segments"] = se.segments
    gruppe= create_group(fid, "positions")
    for i = 1:se.segments
        E = listofSegments[i]
        xx = sol(T, idxs=E.posM[1]).u
        yy = sol(T, idxs=E.posM[2]).u
        zz = sol(T, idxs=E.posM[3]).u
        gruppe["pos$(i)"] = hcat(xx,yy,zz)
    end
end



plot(xx,zz, aspect_ratio=:equal)


