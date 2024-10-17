using Plots
gr(aspect_ratio=:equal, axis=true, ticks=true, legend=false, dpi=200)

d, h = 800, 500  # pixel density (= image width) and image height
n, r = 200, 500  # number of iterations and escape radius (r > 2)

direction, height = 45.0, 1.5  # direction and height of the light
density, intensity = 4.0, 0.5  # density and intensity of the stripes

x = range(0, 2, length=d+1)
y = range(0, 2 * h / d, length=h+1)

A, B = collect(x) .- 1, collect(y) .- h / d
C = (2.0 + 1.0im) .* (A' .+ B .* im) .- 0.5

Z, dZ, ddZ = zero(C), zero(C), zero(C)
D, S, T = zeros(size(C)), zeros(size(C)), zeros(size(C))

for k in 1:n
    M = abs.(Z) .< r
    S[M], T[M] = S[M] .+ sin.(density .* angle.(Z[M])), T[M] .+ 1
    Z[M], dZ[M], ddZ[M] = Z[M] .^ 2 .+ C[M], 2 .* Z[M] .* dZ[M] .+ 1, 2 .* (dZ[M] .^ 2 .+ Z[M] .* ddZ[M])
end

N = abs.(Z) .>= r  # basic normal map effect and stripe average coloring (potential function)
P, Q = S[N] ./ T[N], (S[N] .+ sin.(density .* angle.(Z[N]))) ./ (T[N] .+ 1)
U, V = Z[N] ./ dZ[N], 1 .+ (log2.(log.(abs.(Z[N])) ./ log(r)) .* (P .- Q) .+ Q) .* intensity
U, v = U ./ abs.(U), exp(direction / 180 * pi * im)  # unit normal vectors and light vector
D[N] = max.((real.(U) .* real(v) .+ imag.(U) .* imag(v) .+ V .* height) ./ (1 + height), 0)

heatmap(D .^ 1.0, c=:bone_1)
savefig("Mandelbrot_normal_map_1.png")

N = abs.(Z) .> 2  # advanced normal map effect using higher derivatives (distance estimation)
H, K, L = abs.(Z[N] ./ dZ[N]), abs.(dZ[N] ./ ddZ[N]), log.(abs.(Z[N]))
U = Z[N] ./ dZ[N] .- (H ./ K) .^ 2 .* L ./ (1 .+ L) .* dZ[N] ./ ddZ[N]
U, v = U ./ abs.(U), exp(direction / 180 * pi * im)  # unit normal vectors and light vector
D[N] = max.((real.(U) .* real(v) .+ imag.(U) .* imag(v) .+ height) ./ (1 + height), 0)

heatmap(D .^ 1.0, c=:afmhot)
savefig("Mandelbrot_normal_map_2.png")
