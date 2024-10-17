using Printf, Distributions

newgrid(p::Float64, r::Int, c::Int=r) = rand(Bernoulli(p), r, c)

function walkmaze!(grid::Matrix{Int}, r::Int, c::Int, indx::Int)
    NOT_CLUSTERED = 1 # const
    N, M = size(grid)
    dirs = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    # fill cell
    grid[r, c] = indx
    # check for each direction
    for d in dirs
        rr, cc = (r, c) .+ d
        if checkbounds(Bool, grid, rr, cc) && grid[rr, cc] == NOT_CLUSTERED
            walkmaze!(grid, rr, cc, indx)
        end
    end
end

function clustercount!(grid::Matrix{Int})
    NOT_CLUSTERED = 1 # const
    walkind = 1
    for r in 1:size(grid, 1), c in 1:size(grid, 2)
        if grid[r, c] == NOT_CLUSTERED
            walkind += 1
            walkmaze!(grid, r, c, walkind)
        end
    end
    return walkind - 1
end
clusterdensity(p::Float64, n::Int) = clustercount!(newgrid(p, n)) / n ^ 2

function printgrid(G::Matrix{Int})
    LETTERS = vcat(' ', '#', 'A':'Z', 'a':'z')
    for r in 1:size(G, 1)
        println(r % 10, ") ", join(LETTERS[G[r, :] .+ 1], ' '))
    end
end

G = newgrid(0.5, 15)
@printf("Found %i clusters in this %i×%i grid\n\n", clustercount!(G), size(G, 1), size(G, 2))
printgrid(G)
println()

const nrange = 2 .^ (4:2:12)
const p = 0.5
const nrep = 5
for n in nrange
    sim = mean(clusterdensity(p, n) for _ in 1:nrep)
    @printf("nrep = %2i p = %.2f dim = %-13s sim = %.5f\n", nrep, p, "$n × $n", sim)
end
