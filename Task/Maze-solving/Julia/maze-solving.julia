"""
    +   +---+---+
    | 1   2   3 |
    +---+   +   +
    | 4   5 | 6
    +---+---+---+

    julia> const graph = [
            0 1 0 0 0 0;
            1 0 1 0 1 0;
            0 1 0 0 0 1;
            0 0 0 0 1 0;
            0 1 0 1 0 0;
            0 0 1 0 0 0]

    julia> dist, path = dijkstra(graph, 1)
    (Dict(4=>3,2=>1,3=>2,5=>2,6=>3,1=>0), Dict(4=>5,2=>1,3=>2,5=>2,6=>3,1=>0))

    julia> printpath(path, 6) # Display solution of the maze
    1 -> 2 -> 3 -> 6

"""
function dijkstra(graph, source::Int=1)
    # ensure that the adjacency matrix is squared
    @assert size(graph, 1) == size(graph, 2)
    inf = typemax(Int64)
    n   = size(graph, 1)

    Q    = IntSet(1:n)                  # Set of unvisited nodes
    dist = Dict(n => inf for n in Q)    # Unknown distance function from source to v
    prev = Dict(n => 0   for n in Q)    # Previous node in optimal path from source
    dist[source] = 0                    # Distance from source to source

    function _minimumdist(nodes) # Find the less distant node among nodes
        kmin, vmin = nothing, inf
        for (k, v) in dist
            if k ∈ nodes && v ≤ vmin
                kmin, vmin = k, v
            end
        end
        return kmin
    end
    # Until all nodes are visited...
    while !isempty(Q)
        u = _minimumdist(Q)         # Vertex in Q with smallest dist[]
        pop!(Q, u)
        if dist[u] == inf break end # All remaining vertices are inaccessible from source
        for v in 1:n                # Each neighbor v of u
            if graph[u, v] != 0 && v ∈ Q # where v has not yet been visited
                alt = dist[u] + graph[u, v]
                if alt < dist[v]    # Relax (u, v, a)
                    dist[v] = alt
                    prev[v] = u
                end
            end
        end
    end

    return dist, prev
end

function printpath(prev::Dict, target::Int)
    path = "$target"
    while prev[target] != 0
        target = prev[target]
        path = "$target -> " * path
    end
    println(path)
end

const graph = [
    0 1 0 0 0 0;
    1 0 1 0 1 0;
    0 1 0 0 0 1;
    0 0 0 0 1 0;
    0 1 0 1 0 0;
    0 0 1 0 0 0]

dist, path = dijkstra(graph)
printpath(path, 6)
