mutable struct Cheb
    c::Vector{Float64}
    min::Float64
    max::Float64
end

function Cheb(min::Float64, max::Float64, ncoeff::Int, nnodes::Int, fn::Function)::Cheb
    c = Cheb(Vector{Float64}(ncoeff), min, max)
    f = Vector{Float64}(nnodes)
    p = Vector{Float64}(nnodes)
    z = (max + min) / 2
    r = (max - min) / 2
    for k in 0:nnodes-1
        p[k+1] = π * (k + 0.5) / nnodes
        f[k+1] = fn(z + cos(p[k+1]) * r)
    end
    n2 = 2 / nnodes
    for j in 0:nnodes-1
        s = sum(fk * cos(j * pk) for (fk, pk) in zip(f, p))
        c.c[j+1] = s * n2
    end
    return c
end

function evaluate(c::Cheb, x::Float64)::Float64
    x1 = (2x - c.max - c.min) / (c.max - c.min)
    x2 = 2x1
    t = s = 0
    for j in length(c.c):-1:2
        t, s = x2 * t - s + c.c[j], t
    end
    return x1 * t - s + c.c[1] / 2
end

fn = cos
c  = Cheb(0.0, 1.0, 10, 10, fn)
# coefs
println("Coefficients:")
for x in c.c
    @printf("% .15f\n", x)
end
# values
println("\nx     computed    approximated    computed-approx")
const n = 10
for i in 0.0:n
    x = (c.min * (n - i) + c.max * i) / n
    computed = fn(x)
    approx   = evaluate(c, x)
    @printf("%.1f %12.8f  %12.8f   % .3e\n", x, computed, approx, computed - approx)
end
