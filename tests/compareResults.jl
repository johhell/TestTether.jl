

using HDF5
using Plots
using REPL.TerminalMenus

include("utils.jl")

function Bilderbuch(auswahl::Vector{String})
    T1 = Daten(auswahl[1])
    T2 = Daten(auswahl[2])
    Diff = Daten(T1,T2)

    p1 = plot(;xlabel="x", ylabel="z", title="$(auswahl[1])<=>$(auswahl[2])")
    p2 = plot(;xlabel="time", ylabel="x")
    p3 = plot(;xlabel="time", ylabel="z")
    p4 = plot(;xlabel="time", ylabel="Δx,Δz")


    BildXZ(T1, T2, p1, 5)   #FIXME last segment
    BildX(T1, T2, p2, 5)
    BildZ(T1, T2, p3, 5)
    Bild(Diff, p4, 5)

    p = plot(p1,p2,p3,p4)


    pngName = "$(T1.name)-$(T2.name).png"
    printstyled("savePNG: $(pngName)\n", color= :blue)
    savefig(p, pngName)
    display(p)

end



hdf5Path = "./"
d = readdir(hdf5Path)
d[.!isdir.(d)]   # kein Verzeichnis
inx = findall(x->occursin(".hdf5",x),d)
options = d[inx]


function menu()
    active = true
    while active
        menu = MultiSelectMenu(options, pagesize=10,  charset=:unicode)
        choice = request("", menu)
        if length(choice) > 0
            if length(choice) != 2
                printstyled("Auswahl !=2", color=:red)
            else
                c = collect(choice)
                Bilderbuch(options[c])
            end
        else
            println("Left menu!")
            active = false
        end
    end
end


menu()


