using Graphs, SimpleWeightedGraphs

const chessboardsize = 8
const givenobstacles = [(2,4), (2,5), (2,6), (3,6), (4,6), (5,6), (5,5), (5,4), (5,3), (5,2), (4,2), (3,2)]
vfromcart(p, n) = (p[1] - 1) * n + p[2]
const obstacles = [vfromcart(o .+ 1, chessboardsize) for o in givenobstacles]
zbasedpath(path, n) = [(div(v - 1, n), (v - 1) % n) for v in path]
pathcost(path) = sum(map(x -> x in obstacles ? 100 : 1, path[2:end]))

function surround(x, y, n)
    bottomx = x > 1 ? x -1 : x
    topx = x < n ? x + 1 : x
    bottomy = y > 1 ? y - 1 : y
    topy = y < n ? y + 1 : y
    [CartesianIndex(x,y) for x in bottomx:topx for y in bottomy:topy]
end

function kinggraph(N)
    graph = SimpleWeightedGraph(N*N)
    for row in 1:N, col in 1:N, p in surround(row, col, N)
        origin = vfromcart(CartesianIndex(row, col), N)
        targ = vfromcart(p, N)
        hcost = (targ in obstacles || origin in obstacles) ? 100.0 : 1.0
        add_edge!(graph, origin, targ, hcost)
    end
    graph
end

chebyshev(v) = max(7 - div(v - 1, chessboardsize), 7 - (v - 1) % chessboardsize)

kgraph = kinggraph(chessboardsize)
path_edges = a_star(kgraph, 1, 64, weights(kgraph), chebyshev)
path = [src(first(path_edges)); dst.(path_edges)]
println("Solution has cost $(pathcost(path)):\n", zbasedpath(path, chessboardsize))

path2graphic(x, path) = (x in obstacles ? '█' : x in path ? 'x' : '.')
for row in 8:-1:1, col in 7:-1:0
    print(path2graphic(row*8 - col, path))
    if col == 0
        println()
    end
end
