# run in REPL
using GLMakie

function deathstar()
    n = 60
    θ = [0; (0.5: n - 0.5) / n; 1]
    φ = [(0: 2n - 2) * 2 / (2n - 1); 2]
    # if x is +0.9 radius units, replace it with the coordinates of sphere surface
    # at (1.2,0,0) center, radius 0.5 units
    x = [(x1 = cospi(φ)*sinpi(θ)) > 0.9 ? 1.2 - x1 * 0.5 : x1 for θ in θ, φ in φ]
    y = [sinpi(φ)*sinpi(θ) for θ in θ, φ in φ]
    z = [cospi(θ) for θ in θ, φ in φ]
    scene = Scene(backgroundcolor=:black)
    surface!(scene, x, y, z, color = rand(RGBAf0, 124, 124), show_axis=false)
    return scene
end

scene = deathstar()
