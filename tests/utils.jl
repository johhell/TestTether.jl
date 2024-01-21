
using HDF5

struct ElementPos
    nummer::Int64
    xx::Vector{Float64}
    yy::Vector{Float64}
    zz::Vector{Float64}
    function ElementPos(nr::Int64, xyz::Matrix{Float64})
        x = xyz[:,1]
        y = xyz[:,2]
        z = xyz[:,3]
        new(nr, x,y,z)
    end
    function ElementPos(P1::ElementPos, P2::ElementPos) # Differenz
        nr = P1.nummer
        x = P1.xx .- P2.xx
        y = P1.yy .- P2.yy
        z = P1.zz .- P2.zz
        new(nr, x,y,z)
    end
end


struct Daten
    name::String
    time ::Vector{Float64}
    segments::Int64
    positions::Vector{ElementPos}
    function Daten(hdf)
        FH = h5open("$(hdf).hdf5", "r")
        t = read(FH, "zeit")
        n = read(FH, "model")
        s = read(FH, "segments")
        p = Vector{ElementPos}()
        gruppe= read(FH, "positions")
        for i = 1:s
            pxyz = gruppe["pos$(i)"]
            push!(p,ElementPos(i,pxyz))
        end
        new(n, t, s, p)
    end
    function Daten(T1::Daten,T2::Daten) # Differenz
        n = "Δ $(T1.name)-$(T2.name)"
        t = T1.time
        s = T1.segments
        p = Vector{ElementPos}()
        for i = 1:s
            push!(p,ElementPos(T1.positions[i], T2.positions[i]))
        end
        new(n, t, s, p)
    end
end


function BildXZ(D1::Daten, D2::Daten, plt, indx)    # nur 1 Element
    P1 = D1.positions[indx]
    P2 = D2.positions[indx]
    plot!(plt, P1.xx, P1.zz, label=D1.name)
    plot!(plt, P2.xx, P2.zz, label=D2.name)
end


function BildX(D1::Daten, D2::Daten, plt, indx)    # nur 1 Element
    P1 = D1.positions[indx]
    P2 = D2.positions[indx]
    plot!(plt, D1.time, P1.xx, label=D1.name)
    plot!(plt, D2.time, P2.xx, label=D2.name)
end


function BildZ(D1::Daten, D2::Daten, plt, indx)    # nur 1 Element
    P1 = D1.positions[indx]
    P2 = D2.positions[indx]
    plot!(plt, D1.time, P1.zz, label=D1.name)
    plot!(plt, D2.time, P2.zz, label=D2.name)
end



function Bild(D1::Daten, plt, indx)
    P1 = D1.positions[indx]
    plot!(plt, D1.time, P1.xx, label="$(D1.name).x")
    plot!(plt, D1.time, P1.zz, label="$(D1.name).z")
end

