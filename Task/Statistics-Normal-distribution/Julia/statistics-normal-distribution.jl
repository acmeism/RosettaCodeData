using Printf, Distributions, Gadfly

data = rand(Normal(0, 1), 1000)
@printf("N = %i\n", length(data))
@printf("μ = %2.2f\tσ = %2.2f\n", mean(data), std(data))
@printf("range = (%2.2f, %2.2f\n)", minimum(data), maximum(data))
h = plot(x=data, Geom.histogram)
draw(PNG("norm_hist.png", 10cm, 10cm), h)
