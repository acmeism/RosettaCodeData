using Plots
gr(aspect_ratio=:equal, legend=false, axis=false, ticks=false, dpi=100)

d, h = 400, 300  # pixel density (= image width) and image height
n, r = 40, 1000  # number of iterations and escape radius (r > 2)

x = range(-1.0, 1.0, length=d+1)
y = range(-h/d, h/d, length=h+1)

C = 2.0 .* (x' .+ y .* im) .- 0.5
S, Z = zeros(size(C)), zero(C)

animation = Animation()
smoothing = Animation()

for k in 1:n
    M = abs.(Z) .< r
    S[M] = S[M] .+ exp.(.-abs.(Z[M]))
    Z[M] = Z[M] .^ 2 .+ C[M]
    heatmap(exp.(.-abs.(Z)), c=:jet)
    frame(animation)
    heatmap(S .+ exp.(.-abs.(Z)), c=:jet)
    frame(smoothing)
end

gif(animation, "Mandelbrot_animation.gif", fps=2)
gif(smoothing, "Mandelbrot_smoothing.gif", fps=2)
