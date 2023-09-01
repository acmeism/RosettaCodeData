using Plots
gr(aspect_ratio=:equal, axis=true, ticks=true, legend=false, dpi=200)

d, h = 800, 500  # pixel density (= image width) and image height
n, r = 200, 500  # number of iterations and escape radius (r > 2)

x = range(0, 2, length=d+1)
y = range(0, 2 * h / d, length=h+1)

A, B = collect(x) .- 1, collect(y) .- h / d
C = 2.0 .* (A' .+ B .* im) .- 0.5

Z, dZ = zero(C), zero(C)
D, S, T = zeros(size(C)), zeros(size(C)), zeros(size(C))

for k in 1:n
    M = abs.(Z) .< r
    S[M], T[M] = S[M] .+ exp.(.- abs.(Z[M])), T[M] .+ 1
    Z[M], dZ[M] = Z[M] .^ 2 .+ C[M], 2 .* Z[M] .* dZ[M] .+ 1
end

heatmap(S .^ 0.1, c=:balance)
savefig("Mandelbrot_set_1.png")

N = abs.(Z) .>= r  # normalized iteration count
T[N] = T[N] .- log2.(log.(abs.(Z[N])) ./ log(r))

heatmap(T .^ 0.1, c=:balance)
savefig("Mandelbrot_set_2.png")

N = abs.(Z) .> 2  # exterior distance estimation
D[N] = log.(abs.(Z[N])) .* abs.(Z[N]) ./ abs.(dZ[N])

heatmap(D .^ 0.1, c=:balance)
savefig("Mandelbrot_set_3.png")

N, thickness = D .> 0, 0.01  # boundary detection
D[N] = max.(1 .- D[N] ./ thickness, 0)

heatmap(D .^ 2.0, c=:binary)
savefig("Mandelbrot_set_4.png")
