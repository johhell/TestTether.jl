
module Bilder

using HDF5
using Plots

include("utils.jl")


T1 = Daten("T7modia")
T2 = Daten("../modelica/F22")
Diff = Daten(T1,T2)


p1 = plot(;xlabel="x", ylabel="z")
p2 = plot(;xlabel="time", ylabel="x")
p3 = plot(;xlabel="time", ylabel="z")
p4 = plot(;xlabel="time", ylabel="Δx,Δz")


BildXZ(T1, T2, p1, 5)   #FIXME last segment
BildX(T1, T2, p2, 5)
BildZ(T1, T2, p3, 5)
Bild(Diff, p4, 5)


p = plot(p1,p2,p3,p4)
savefig(p, "ModiaModelica.png")
display(p)


end


