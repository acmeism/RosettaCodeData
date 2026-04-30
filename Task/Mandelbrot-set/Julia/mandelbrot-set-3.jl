using Plots
gr(aspect_ratio=:equal, legend=false, axis=false, ticks=false)

d, h = 800, 600  # pixel density (= image width) and image height
n, r = 20, 1000  # number of iterations and escape radius (r > 2)

x = range(-1.0, 1.0, length=d)
y = range(-h/d, h/d, length=h)

C = 1.6 .* (x' .+ y .* im) .- 0.6
S, Z = zeros(size(C)), zero(C)

animation, smoothing = Animation(), Animation()
gr(size=(d, h), margins=-8*Plots.px, dpi=100, c=:jet)

for k in 1:n
    M = abs.(Z) .< r
    S[M] = S[M] .+ exp.(.-abs.(Z[M]))
    Z[M] = Z[M] .^ 2 .+ C[M]
    heatmap(exp.(.-abs.(Z)))
    frame(animation)
    heatmap(S .+ exp.(.-abs.(Z)))
    frame(smoothing)
end

gif(animation, "Mandelbrot_animation.gif", fps=1)
gif(smoothing, "Mandelbrot_smoothing.gif", fps=1)
