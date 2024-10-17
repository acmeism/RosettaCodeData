using Printf, Distributions

struct Grid
    cells::BitArray{2}
    hwall::BitArray{2}
    vwall::BitArray{2}
end
function Grid(p::AbstractFloat, m::Integer=10, n::Integer=10)
    cells = fill(false, m, n)
    hwall = rand(Bernoulli(p), m + 1, n)
    vwall = rand(Bernoulli(p), m, n + 1)
    vwall[:, 1] = true
    vwall[:, end] = true
    return Grid(cells, hwall, vwall)
end

function Base.show(io::IO, g::Grid)
    H = (" .", " _")
    V = (":", "|")
    C = (" ", "#")
    ind = findfirst(g.cells[end, :] .& .!g.hwall[end, :])
    percolated = !iszero(ind)
    println(io, "$(size(g.cells, 1))×$(size(g.cells, 2)) $(percolated ? "Percolated" : "Not percolated") grid")
    for r in 1:size(g.cells, 1)
        println(io, "    ", join(H[w+1] for w in g.hwall[r, :]))
        println(io, " $(r % 10)) ", join(V[w+1] * C[c+1] for (w, c) in zip(g.vwall[r, :], g.cells[r, :])))
    end
    println(io, "    ", join(H[w+1] for w in g.hwall[end, :]))
    if percolated
        println(io, " !)  ", "  " ^ (ind - 1), '#')
    end
end

function floodfill!(m::Integer, n::Integer, cells::AbstractMatrix{<:Integer},
                    hwall::AbstractMatrix{<:Integer}, vwall::AbstractMatrix{<:Integer})
    # fill cells
    cells[m, n] = true
    percolated = false
    # bottom
    if m < size(cells, 1) && !hwall[m+1, n] && !cells[m+1, n]
        percolated = percolated || floodfill!(m + 1, n, cells, hwall, vwall)
    # The Bottom
    elseif m == size(cells, 1) && !hwall[m+1, n]
        return true
    end
    # left
    if n > 1 && !vwall[m, n] && !cells[m, n-1]
        percolated = percolated || floodfill!(m, n - 1, cells, hwall, vwall)
    end
    # right
    if n < size(cells, 2) && !vwall[m, n+1] && !cells[m, n+1]
        percolated = percolated || floodfill!(m, n + 1, cells, hwall, vwall)
    end
    # top
    if m > 1 && !hwall[m, n] && !cells[m-1, n]
        percolated = percolated || floodfill!(m - 1, n, cells, hwall, vwall)
    end
    return percolated
end
function pourontop!(g::Grid)
    m, n = 1, 1
    percolated = false
    while !percolated && n ≤ size(g.cells, 2)
        percolated = !g.hwall[m, n] && floodfill!(m, n, g.cells, g.hwall, g.vwall)
        n += 1
    end
    return percolated
end

function main(probs, nrep::Integer=1000)
    sampleprinted = false
    pcount = zeros(Int, size(probs))
    for (i, p) in enumerate(probs), _ in 1:nrep
        g = Grid(p)
        percolated = pourontop!(g)
        if percolated
            pcount[i] += 1
            if !sampleprinted
                println(g)
                sampleprinted = true
            end
        end
    end
    return pcount ./ nrep
end

probs = collect(10:-1:0) ./ 10
percprobs = main(probs)

println("Fraction of 1000 tries that percolate through:")
for (pr, pp) in zip(probs, percprobs)
    @printf("\tp = %.3f ⇒ freq. = %5.3f\n", pr, pp)
end
