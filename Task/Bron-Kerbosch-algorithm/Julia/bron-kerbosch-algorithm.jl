"""
For rosettacode.org/wiki/Bron–Kerbosch_algorithm

The implementation below is taken from the Graphs julia package at
https://github.com/JuliaGraphs/Graphs.jl/blob/ec6ab1b0e267e2b1722837aa113e8da9a405785b/src/community/cliques.jl

Because the Graphs.jl package uses integers for vertex labels, the letters in the Rust example are converted
to and from integers for program testing.
"""

mutable struct SimpleGraph{T <: Integer}
    ne::T
    vertices::Vector{T}
    edges::Set{Tuple{T, T}}
    adjacencies::Vector{Set{T}}
end

function SimpleGraph(ne::T, edge_list) where T <: Integer
    vertices = collect(1:ne)
    edges = Set{Tuple{T, T}}()
    sets = [Set{T}() for _ in vertices]
    for e in edge_list
        push!(edges, e, reverse(e))
        push!(sets[e[1]], e[2])
        push!(sets[e[2]], e[1])
    end
    return SimpleGraph{T}(ne, vertices, edges, sets)
end
vertices(g::SimpleGraph) = g.vertices
edges(g::SimpleGraph) = g.edges
neighbors(g, v) = g.adjacencies[v]

function Bron_Kerbosch_maximal_cliques(g::SimpleGraph{T}) where T
    max_connections = -1
    n_numbers = [Set{T}() for n in vertices(g)]
    pivot_numbers = Set{T}() # handle empty graph
    pivot_done_numbers = Set{T}()  # initialize

    for n in vertices(g)
        nbrs = Set{T}()
        union!(nbrs, neighbors(g, n))
        delete!(nbrs, n) # ignore edges between n and itself
        conn = length(nbrs)
        if conn > max_connections
            pivot_numbers = nbrs
            n_numbers[n] = pivot_numbers
            max_connections = conn
        else
            n_numbers[n] = nbrs
        end
    end

    # Initial setup
    cand = Set{T}(vertices(g))
    smallcand = setdiff(cand, pivot_numbers)
    done = Set{T}()
    stack = Vector{Tuple{Set{T}, Set{T}, Set{T}}}()
    clique_so_far = Vector{T}()
    cliques = Vector{Vector{T}}()

    # Start main loop
    while !isempty(smallcand) || !isempty(stack)
        if !isempty(smallcand) # Any vertices left to check?
            n = pop!(smallcand)
        else
            # back out clique_so_far
            cand, done, smallcand = pop!(stack)
            pop!(clique_so_far)
            continue
        end
        # Add next node to clique
        push!(clique_so_far, n)
        delete!(cand, n)
        push!(done, n)
        nn = n_numbers[n]
        new_cand = intersect(cand, nn)
        new_done = intersect(done, nn)
        # check if we have more to search
        if isempty(new_cand)
            if isempty(new_done)
                # Found a clique!
                push!(cliques, collect(clique_so_far))
            end
            pop!(clique_so_far)
            continue
        end
        # Shortcut--only one node left!
        if isempty(new_done) && length(new_cand) == 1
            push!(cliques, vcat(clique_so_far, collect(new_cand)))
            pop!(clique_so_far)
            continue
        end
        # find pivot node (max connected in cand)
        # look in done vertices first
        numb_cand = length(new_cand)
        max_connections_done = -1
        for n in new_done
            cn = intersect(new_cand, n_numbers[n])
            conn = length(cn)
            if conn > max_connections_done
                pivot_done_numbers = cn
                max_connections_done = conn
                if max_connections_done == numb_cand
                    break
                end
            end
        end
        # Shortcut--this part of tree already searched
        if max_connections_done == numb_cand
            pop!(clique_so_far)
            continue
        end
        # still finding pivot node
        # look in cand vertices second
        max_connections = -1
        for n in new_cand
            cn = intersect(new_cand, n_numbers[n])
            conn = length(cn)
            if conn > max_connections
                pivot_numbers = cn
                max_connections = conn
                if max_connections == numb_cand - 1
                    break
                end
            end
        end
        # pivot node is max connected in cand from done or cand
        if max_connections_done > max_connections
            pivot_numbers = pivot_done_numbers
        end
        # save search status for later backout
        push!(stack, (cand, done, smallcand))
        cand = new_cand
        done = new_done
        smallcand = setdiff(cand, pivot_numbers)
    end
    return cliques
end

char(i) = Char(Int32('a') + i - 1)
int(t) = Tuple(Int32(x) .- Int32('a') .+ 1 for x in t)

TEST_EDGES = [('a', 'b'), ('a', 'c'), ('b', 'a'), ('b', 'c'), ('c', 'a'), ('c', 'b'),
    ('d', 'e'), ('d', 'f'), ('e', 'd'), ('e', 'f'), ('f', 'd'), ('f', 'e')]
g_test = SimpleGraph(6, map(int, TEST_EDGES))

println("\nBron-Kerbosch maximal cliques: ")
println([sort!(map(char, clique)) for clique in Bron_Kerbosch_maximal_cliques(g_test)])
