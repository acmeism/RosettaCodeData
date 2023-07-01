using Plots
gr(aspect_ratio=:equal, axis=true, ticks=true, legend=false, dpi=200)

setprecision(BigFloat, 256)  # set precision to 256 bits (default)
setrounding(BigFloat, RoundNearest)  # set rounding mode (default)

d, h = 50, 1000  # pixel density (= image width) and image height
n, r = 80000, 100000  # number of iterations and escape radius (r > 2)

a = BigFloat("-1.256827152259138864846434197797294538253477389787308085590211144291")
b = BigFloat(".37933802890364143684096784819544060002129071484943239316486643285025")

S = zeros(Complex{Float64}, n+1)
let c = a + b * im, z = zero(c)
    for k in 1:n+1
        S[k] = z
        if abs2(z) < abs2(r)
            z = z ^ 2 + c
        else
            println("The reference sequence diverges within $(k-1) iterations.")
            break
        end
    end
end

x = range(0, 2, length=d+1)
y = range(0, 2 * h / d, length=h+1)

A, B = collect(x) .* pi, collect(y) .* pi
C = 8.0 .* exp.((A' .+ B .* im) .* im)

E, Z, dZ = zero(C), zero(C), zero(C)
D, I, J = zeros(size(C)), ones(Int64, size(C)), ones(Int64, size(C))

for k in 1:n
    M, R = abs2.(Z) .< abs2(r), abs2.(Z) .< abs2.(E)
    E[R], I[R] = Z[R], J[R]  # rebase when z is closer to zero
    E[M], I[M] = (2 .* S[I[M]] .+ E[M]) .* E[M] .+ C[M], I[M] .+ 1
    Z[M], dZ[M] = S[I[M]] .+ E[M], 2 .* Z[M] .* dZ[M] .+ 1
end

N = abs.(Z) .> 2  # exterior distance estimation
D[N] = log.(abs.(Z[N])) .* abs.(Z[N]) ./ abs.(dZ[N])

heatmap(D' .^ 0.015, c=:nipy_spectral)
savefig("Mercator_Mandelbrot_deep_map.png")
