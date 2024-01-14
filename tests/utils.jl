

mutable struct Daten
    name::String
    xx::Vector{Float64}
    zz::Vector{Float64}
    time ::Vector{Float64}
    function Daten(jld)
        T7 = JLD2.load("$(jld).jld2")
        new(jld, T7["xx"], T7["zz"], T7["T"])
    end
    function Daten(T1::Daten,T2::Daten) # Differenz
       new("Δ $(T1.name)-$(T2.name)", T1.xx.-T2.xx, T1.zz.-T2.zz, T1.time)
    end
end


function BildXZ(D1::Daten, D2::Daten, plt)
    plot!(plt, D1.xx, D1.zz, label=D1.name)
    plot!(plt, D2.xx, D2.zz, label=D2.name)
end


function BildX(D1::Daten, D2::Daten, plt)
    plot!(plt, D1.time, D1.xx, label=D1.name)
    plot!(plt, D2.time, D2.xx, label=D2.name)
end

function BildZ(D1::Daten, D2::Daten, plt)
    plot!(plt, D1.time, D1.zz, label=D1.name)
    plot!(plt, D2.time, D2.zz, label=D2.name)
end

function Bild(D1::Daten, plt)
    plot!(plt, D1.time, D1.xx, label="$(D1.name).x")
    plot!(plt, D1.time, D1.zz, label="$(D1.name).z")
end
