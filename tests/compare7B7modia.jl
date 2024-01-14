
module Bilder

using JLD2
using Plots

include("utils.jl")

T1 = Daten("T7modia")
T2 = Daten("T7B")
Diff = Daten(T1,T2)


p1 = plot(;xlabel="x", ylabel="z")
p2 = plot(;xlabel="time", ylabel="x")
p3 = plot(;xlabel="time", ylabel="z")
p4 = plot(;xlabel="time", ylabel="Δx,Δz")


BildXZ(T1, T2, p1)
BildX(T1, T2, p2)
BildZ(T1, T2, p3)
Bild(Diff, p4)


p = plot(p1,p2,p3,p4)
savefig(p, "7B7modia.png")
display(p)


end


