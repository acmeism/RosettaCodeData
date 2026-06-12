struct Graph
    n::Int
    adj::Matrix{Bool}
end
Graph(n) = Graph(n, falses(n, n))

""" Add an undirected edge u--v. """
function add_edge!(g::Graph, u, v)
    if 0 < u <= g.n && 0 < v <= g.n
        g.adj[u, v] = true
        g.adj[v, u] = true
    end
end

""" Degree of vertex u. """
degree(g::Graph, u) = count(@view g.adj[u, :])

""" Compute the Chvátal closure in‑place. """
function closure!(g::Graph)
    n = g.n
    while true
        added = false
        # Try every non-edge (u,v) with u < v
        for u in 1:n-1, v in u+1:n
            if !g.adj[u, v]
                du = degree(g, u)
                dv = degree(g, v)
                if du + dv > n
                    # add the edge
                    add_edge!(g, u, v)
                    added = true
                    break
                end
            end
        end
        !added && break
    end
end

""" Is the graph complete? """
function is_complete(g::Graph)
    for u in 1:g.n, v in u+1:g.n
        !g.adj[u, v] && return false
    end
    return true
end

function dfs(g::Graph, u, visited, path)
    if length(path) == g.n
        # check if can close the cycle
        return g.adj[u, path[begin]] ? [path; path[begin]] : nothing
    end
    for v in 1:g.n
        if !visited[v] && g.adj[u, v]
            visited[v] = true
            push!(path, v)
            cycle = dfs(g, v, visited, path)
            !isnothing(cycle) && return cycle
            # else backtrack if no cycle yet
            pop!(path)
            visited[v] = false
        end
    end
    return nothing
end

""" Find a Hamiltonian cycle in the original graph (not closure)
    by simple backtracking. Returns vertices in order (0..n-1), and back to start.
"""
function hamiltonian_cycle(g::Graph)
    visited = falses(g.n)
    # set starting vertex
    path = [1]
    visited[begin] = true
    return dfs(g, 1, visited, path)
end

function test_hamiltonian()
    # Example: 5 vertices, almost complete graph missing edge 0--1.
    # This satisfies Ore's condition: any non-edge (0,1) has deg(0)=3, deg(1)=3, 3+3>=5.
    g = Graph(5)
    # Add all edges except (0,1)
    for u in 1:4
        for v in u+1:5
            if !(u == 1 && v == 2)
                add_edge!(g, u, v)
            end
        end
    end

    println("Original graph degrees:")
    for u in 1:g.n
        println(" deg($u) = ", degree(g, u))
    end

    # Compute closure
    c = Graph(g.n, copy(g.adj))
    closure!(c)

    println("\nAfter Chvátal closure (translated to 0-based indices):")
    for u in 1:c.n
        print(u - 1, ": ")
        for v in 1:c.n
            if c.adj[u, v]
                print(v - 1, " ")
            end
        end
        println()
    end

    if is_complete(c)
        println("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).")
        cycle = hamiltonian_cycle(g)
        if !isnothing(cycle)
            println("Found Hamiltonian cycle in original graph, as zero-based is:")
            for (i, v) in enumerate(cycle)
                i > 1 && print(" → ")
                print(v - 1)
            end
            println()
        else
            println("Unexpected: could not find a Hamiltonian cycle.")
        end
    else
        println("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.")
    end
end

test_hamiltonian()
