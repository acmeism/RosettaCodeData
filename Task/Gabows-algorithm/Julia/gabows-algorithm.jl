import Base.string, Base.count

""" Digraph represents a directed graph using adjacency lists
    Note that Julia uses 1 based indexing so numbers from 1 not 0
    Test output converts back to 0 based for comparable output
"""
mutable struct Digraph
    v::Int # number of vertices
    e::Int     # number of edges
    adj::Vector{Vector{Int}} # adjacency lists
end

""" makes an empty digraph with v vertices """
function Digraph(v::Integer)
    @assert v >= 0 "number of vertices must be non-negative"
    return Digraph(v, 0, [Int[] for _ in 1:v])
end

""" nv returns the number of vertices """
nv(g::Digraph) = g.v

""" ne returns the number of edges """
ne(g::Digraph) = g.e

""" validatevertex raises an error if v is not a valid vertex """
function validatevertex(g::Digraph, v::Integer)
    @assert 0 < v <= g.v "Domain error with v $v: required that 0 < v <= $(g.v)"
end

""" addedge! adds the directed edge v->w to the digraph """
function addedge!(g::Digraph, v, w)
    validatevertex(g, v)
    validatevertex(g, w)
    push!(g.adj[v], w)
    g.e += 1
end

""" Adj returns the list of neighbors adjacent from vertex v """
function adj(g::Digraph, v::Integer)
    validatevertex(g, v)
    return g.adj[v]
end

""" returns a string representation of the digraph """
function string(g::Digraph, zerobasedoutput = true)
    s = "$(nv(g)) vertices, $(ne(g)) edges\n"
    for v in eachindex(g.adj)
        s *= "$v: " * join([string(i - zerobasedoutput) for i in g.adj[v]], " ") * "\n"
    end
    return s
end

""" strongly connected components in a digraph using Gabow's algorithm """
mutable struct GabowSCC
    marked::Vector{Bool} # marked[v] = has v been visited?
    id::Vector{Int}  # id[v] = id of strong component containing v
    preorder::Vector{Int}  # preorder[v] = preorder of v
    precounter::Int # preorder number counter
    scc_count::Int    # number of strongly-connected components
    stack1::Vector{Int} # Stores vertices in order of visitation
    stack2::Vector{Int} # Auxiliary stack for finding SCC roots
end

""" Computes the strong components of the digraph G as a GabowSCC """
function GabowSCC(g::Digraph)
    marked = falses(nv(g))
    id = fill(-1, nv(g)) # Initialize id array with -1
    preorder = zeros(Int, nv(g))
    scc = GabowSCC(marked, id, preorder, 0, 1, Int[], Int[])
    for v in 1:nv(g)
        !scc.marked[v] && dfs!(scc, g, v)
    end
    return scc
end

""" dfs! implements depth-first search core logic for Gabow's algorithm """
function dfs!(scc::GabowSCC, g::Digraph, v::Integer)
    scc.marked[v] = true
    scc.precounter += 1
    scc.preorder[v] = scc.precounter
    push!(scc.stack1, v)
    push!(scc.stack2, v)

    for w in g.adj[v]
        if !scc.marked[w]
            dfs!(scc, g, w)
        elseif scc.id[w] == -1
            # Pop vertices from stack2 until top has preorder number <= preorder[w]
            while !isempty(scc.stack2) && scc.preorder[scc.stack2[end]] > scc.preorder[w]
                pop!(scc.stack2)
            end
        end
    end

    # If v at end of stack2 is the root of an SCC
    if !isempty(scc.stack2) && scc.stack2[end] == v
        pop!(scc.stack2) # remove v from stack2
        # Pop vertices from stack1 until v is found; assign them the current SCC id
        while !isempty(scc.stack1)
            w = pop!(scc.stack1)
            scc.id[w] = scc.scc_count
            w == v && break
        end
        scc.scc_count += 1
    end
end

""" returns the number of strong components """
count(scc::GabowSCC) = scc.scc_count - 1

""" raises an error if v is not a valid vertex """
function validatevertex(scc::GabowSCC, v::Integer)
    len = length(scc.marked)
    @assert 0 < v <= len "vertex $v is not between 0 and $len"
end

""" returns true if vertices v and w are in the same strong component """
function stronglyconnected(scc::GabowSCC, v::Integer, w::Integer)
    validatevertex(scc, v)
    validatevertex(scc, w)
    return scc.id[v] != -1 && scc.id[v] == scc.id[w]
end

""" returns the component id of the strong component containing vertex v """
id(scc::GabowSCC, v::Integer) = (validatevertex(scc, v); scc.id[v])

function testgabow()
    # Manually construct the digraph (same as in Python code)
    numVertices = 13
    g = Digraph(numVertices)

    edges = [
        [4, 2], [2, 3], [3, 2], [6, 0], [0, 1], [2, 0], [11, 12],
        [12, 9], [9, 10], [9, 11], [8, 9], [10, 12], [0, 5], [5, 4],
        [3, 5], [6, 4], [6, 9], [7, 6], [7, 8], [8, 7], [5, 3], [0, 6],
    ]

    for (v, w) in edges
        addedge!(g, v + 1, w + 1)
    end
    println("Constructed Digraph:\n$(string(g))")

    # Compute SCCs
    scc = GabowSCC(g)

    # Print results
    m = count(scc)
    println("$m strongly connected components:")

    # Group vertices by component ID
    components = [Int[] for _ in 1:m]
    for v in 1:nv(g)
        componentID = id(scc, v)
        if componentID != -1
            push!(components[componentID], v)
        else
            println("Warning: Vertex $v has no SCC ID assigned.\n")
        end
    end
    for i in 1:m
        println("Component $(i-1): ", join([string(components[i][j] - 1) for j in eachindex(components[i])], " "))
    end

    # Example usage of stronglyconnected and id
    println("\nConnectivity checks:")
    for (v, w) in [(0, 3), (0, 7), (9, 12)]
        println("Vertices $v and $w strongly connected? ",
            stronglyconnected(scc, v + 1, w + 1))
    end
    println("ID of vertex 5: ", id(scc, 5 + 1) - 1)
    println("ID of vertex 8: ", id(scc, 8 + 1) - 1)
end

testgabow()
