using UnicodePlots

spiral(θ, a=0, b=1) = @. b * θ * cos(θ + a), b * θ * sin(θ + a)

x, y = spiral(1:0.1:10)
println(lineplot(x, y))
