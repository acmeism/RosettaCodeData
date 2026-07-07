using Printf
using Format
using Primes

struct Spiral
    m::Int
    n::Int
    cmax::Int
    dir::Array{Array{Int,1},1}
    bdelta::Array{Array{Int,1},1}
end

function Spiral(m::Int, n::Int)
    cmax = m*n
    dir = Array{Int,1}[[0,1], [1,0], [0,-1], [-1,0]]
    bdelta = Array{Int,1}[[0,0,0,1], [-1,0,0,0],
                          [0,-1,0,0], [0,0,1,0]]
    Spiral(m, n, cmax, dir, bdelta)
end

function spiral(m::Int, n::Int)
    0<m&&0<n || error("The matrix dimensions must be positive.")
    Spiral(m, n)
end
spiral(n::Int) = spiral(n, n)

mutable struct SpState
    cnt::Int
    dirdex::Int
    cell::Array{Int,1}
    bounds::Array{Int,1}
end

Base.length(sp::Spiral) = sp.cmax
start(sp::Spiral) = SpState(1, 1, [1,1], [sp.n,sp.m,1,1])

function Base.iterate(sp::Spiral, sps::SpState = start(sp))
    sps.cnt > sp.cmax && return nothing
    s = LinearIndices((sp.m, sp.n))[sps.cell[1], sps.cell[2]]
    if sps.cell[mod1(sps.dirdex+1, 2)] == sps.bounds[sps.dirdex]
        sps.bounds += sp.bdelta[sps.dirdex]
        sps.dirdex = mod1(sps.dirdex+1, 4)
    end
    sps.cell += sp.dir[sps.dirdex]
    sps.cnt += 1
    return (s, sps)
end

function width(n)
    w = ndigits(n)
    n < 0 || return w
    return w + 1
end

function pretty(a::Array{T,2}, indent::Int=4) where T <: Integer
    lo, hi = extrema(a)
    w = max(width(lo), width(hi))
    id = " "^indent
    fe = FormatExpr(@sprintf(" {:%dd}", w))
    s = id
    nrow = size(a)[1]
    for i in 1:nrow
        for j in a[i,:]
            s *= format(fe, j)
        end
        i != nrow || continue
        s *= "\n"*id
    end
    return s
end

n = 5
println("The n = ", n, " spiral matrix:")
a = zeros(Int, (n, n))
for (i, s) in enumerate(spiral(n))
    a[s] = i-1
end
println(pretty(a))

m = 3
println()
println("Generalize to a non-square matrix (", m, "x", n, "):")
a = zeros(Int, (m, n))
for (i, s) in enumerate(spiral(m, n))
    a[s] = i-1
end
println(pretty(a))

p = primes(10^3)
n = 7
println()
println("An n = ", n, " prime spiral matrix:")
a = zeros(Int, (n, n))
for (i, s) in enumerate(spiral(n))
    a[s] = p[i]
end
println(pretty(a))
