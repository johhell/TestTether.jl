
using JLD2
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
xx = sol(T, idxs=pos[1,lastIndex]).u
zz = sol(T, idxs=pos[3,lastIndex]).u

jldsave("T7A.jld2"; T, xx,zz)

plot(xx,zz, aspect_ratio=:equal)


