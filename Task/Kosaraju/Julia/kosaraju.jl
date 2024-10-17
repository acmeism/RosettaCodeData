function korasaju(g::Vector{Vector{T}}) where T<:Integer
    # 1. For each vertex u of the graph, mark u as unvisited. Let L be empty.
    vis = falses(length(g))
    L   = Vector{T}(length(g))
    x   = length(L) + 1
    t   = collect(T[] for _ in eachindex(g))

    # Recursive
    function visit(u::T)
        if !vis[u]
            vis[u] = true
            for v in g[u]
                visit(v)
                push!(t[v], u)
            end
            x -= 1
            L[x] = u
        end
    end
    # 2. For each vertex u of the graph do visit(u)
    for u in eachindex(g)
        visit(u)
    end
    c = Vector{T}(length(g))
    # 3. Recursive subroutine:
    function assign(u::T, root::T)
        if vis[u]
            vis[u] = false
            c[u] = root
            for v in t[u]
                assign(v, root)
            end
        end
    end
    # 3. For each element u of L in order, do assign(u, u)
    for u in L
        assign(u, u)
    end
    return c
end

g = [[2], [3], [1], [2, 3, 5], [4, 6], [3, 7], [6], [5, 7, 8]]
println(korasaju(g))
