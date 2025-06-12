using Base.Threads
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

A, B = collect(Float64, x) .* pi, collect(Float64, y) .* pi
C = (- 8.0) .* exp.((A' .+ B .* im) .* im)

function iteration(C)
    E, I, J = zero(C), ones(Int64, size(C)), ones(Int64, size(C))
    Z, dZ = zero(C), zero(C)

    function iterate(E, I, Z, dZ, C)
        E, I = (2 .* S[I] .+ E) .* E .+ C, I .+ 1
        Z, dZ = S[I] .+ E, 2 .* Z .* dZ .+ 1
        return E, I, Z, dZ
    end

    for k in 1:n
        M = abs2.(Z) .< abs2.(E)
        E[M], I[M] = Z[M], J[M]  # rebase when z is closer to zero
        M = abs2.(Z) .< abs2(r)
        E[M], I[M], Z[M], dZ[M] = iterate(E[M], I[M], Z[M], dZ[M], C[M])
    end

    return E, I, Z, dZ
end

function calculation(C)
    E, I = zero(C), ones(Int64, size(C))
    Z, dZ = zero(C), zero(C)

    @threads for j in 1:size(C)[2]
        E[:,j], I[:,j], Z[:,j], dZ[:,j] = iteration(C[:,j])
    end

    return E, I, Z, dZ
end

E, I, Z, dZ = calculation(C)
D = zeros(Float64, size(C))

N = abs.(Z) .> 2  # exterior distance estimation
D[N] = log.(abs.(Z[N])) .* abs.(Z[N]) ./ abs.(dZ[N])

heatmap(D' .^ 0.015, c=:gist_ncar)
savefig("Mercator_Mandelbrot_deep_map.png")
