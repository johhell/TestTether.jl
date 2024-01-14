# TestTether.jl


Testing different approaches for tether chain models.

The following 3 models are considered

* `Tether_07A.jl` - the original version using MTK ecosystem - only the calculation of cross-section was corrected.
* `Tether_07B.jl` - a modified version (see PR)
* `T7modia.jl` - a Modia3D implementation - only for verification


## Installation

It's assumed that the `ModelingToolkit` ecosystem is already installed.

It's recommended to use the latest versions from `Modia` and `Modia3D`

> ```julia
>using Pkg
>Pkg.add("https://github.com/ModiaSim/Modia.jl.git")
>Pkg.add("https://github.com/ModiaSim/Modia3D.jl.git")
>Pkg.add("Plots")
>Pkg.add("JLD2")
>```

## Models
Do make it easier to compare, the original model was simplified.

The reel-out speed was set to zero. `v_ro = 0.0   # reel-out speed  [m/s]`, so the model was reduced to a multi-element pendulum. All other parametres remain unchanged.

### `Tether_07A.jl`

### `Tether_07B.jl`

### `T7modia.jl`


## performed Tests


## Discussion
