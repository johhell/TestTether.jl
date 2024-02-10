
using Parameters

# TODO: Add aerodynamic drag

@with_kw mutable struct Settings @deftype Float64
    g_earth::Vector{Float64} = [0.0, 0.0, -9.81] # gravitational acceleration     [m/s²]
    l0 = 50                                      # initial tether length             [m]
    v_ro = 0.0# 2                                     # reel-out speed                  [m/s]
    d_tether = 4                                 # tether diameter                  [mm]
    rho_tether = 724                             # density of Dyneema            [kg/m³]
    c_spring = 614600                            # unit spring constant              [N]
    damping = 473                                # unit damping constant            [Ns]
    segments::Int64 = 5                          # number of tether segments         [-]
    α0 = π/10                                    # initial tether angle            [rad]
    duration = 10                                # duration of the simulation        [s]
    save::Bool = false                           # save png files in folder video

    mass_per_meter = rho_tether * pi * (d_tether/2000.0)^2
    len_per_segment = l0 / segments
    mass_per_seg = mass_per_meter * len_per_segment
    frictionCoeff = 0.1e-3                      # N/m/(m/s)^2
    wind_speed::Vector{Float64} = [0.0, 0.0, 1e-6]  # NOT zero !!
end
