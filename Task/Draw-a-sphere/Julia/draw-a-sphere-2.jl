# run from REPL

using Makie

φ = 0:π/100:2π

θ = 0:π/200:π

x = [cos(θ) * sin(φ) for θ in θ, φ in φ]
y = [sin(θ)*sin(φ) for θ in θ, φ in φ]
z = [cos(φ) for θ in θ, φ in φ]

surface(x, y, z, backgroundcolor = :black, show_axis = false)
