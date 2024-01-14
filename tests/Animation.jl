
# module Bilder

using Plots
using Modia
using Printf
using JLD2


J = JLD2.load("X7modia.jld2")
segments = J["segments"]
MM::Vector{Matrix}  = J["positions"]
zeit = J["T"]
N = size(MM[1])[1]


schritte = 100
d = Int(round(N/schritte))
indPkt = collect(1:d:N)


struct Zeitpunkt
    time::Float64
    xp::Vector{Float64}
    yp::Vector{Float64}
    zp::Vector{Float64}
    function Zeitpunkt(t,x,y,z)
        new(t,x,y,z)
    end
end


function Bild(pkt::Zeitpunkt)
    txt = @sprintf("time: %4.1f",pkt.time)

    pt1 = plot(;ylim=[-55.0,10], xlim=[-50.0,50.0], aspect_ratio=:equal, legend=false, xlabel="x", ylabel="z")
    plot!(pt1,pkt.xp,pkt.zp)
    scatter!(pt1,pkt.xp, pkt.zp)

    pt2 = plot(;ylim=[-55.0,10], xlim=[-50.0,50.0], aspect_ratio=:equal, legend=false, xlabel="y", ylabel="z")
    plot!(pt2,pkt.yp,pkt.zp)
    scatter!(pt2,pkt.yp, pkt.zp)
    annotate!(pt1,[(0, -5.0, (txt, 8, 0.0, :bottom, :red))])
    display(plot(pt1, pt2, size=(800,400)))
end

function Bild3D(pkt::Zeitpunkt)
    pt1 = plot(;xlim=[-20.1,20.1], ylim=[-20.0,20.0], zlim=[-50,0], legend=false)
    plot!(pt1,pkt.xp,pkt.yp,pkt.zp)
    scatter!(pt1,pkt.xp,pkt.yp, pkt.zp)
    txt = @sprintf("time: %4.1f",pkt.time)
    annotate!([(0, 0, (txt, 8, 0.0, :bottom, :red))])
    display(pt1)
end


linie = Vector{Zeitpunkt}()


function GrafDaten(M::Vector{Matrix}, zz, indx::Int64)::Zeitpunkt
    time = zz[indx]
    x = Vector{Float64}()
    y = Vector{Float64}()
    z = Vector{Float64}()
    for v in M
        push!(x,v[indx,1])
        push!(y,v[indx,2])
        push!(z,v[indx,3])
    end
    Zeitpunkt(time, x,y,z)
end




for i in indPkt
    push!(linie, GrafDaten(MM,zeit, i))
end




for k in linie
    Bild(k)
end





# anim = @animate for k in linie
#     Bild(k)
# end
# gif(anim, "D50.gif")

# end
