const Edge = Tuple{Int, Int, Int}

""" Structure to represent a graph """
struct Graph
    v::Int # Number of vertices
    graph::Vector{Edge} # List of Edges [vertex u, vertex v, weight]
end
Graph(vertices) = Graph(vertices, Vector{Int}[])

""" Function to add an edge to the graph with adjust for basis (1 vs 0) of vertex array """
add_edge!(g::Graph, u, v, wt, adjust = true) = push!(g.graph, (u + adjust, v + adjust, wt))

""" A utility function to find the set of an element i (uses path compression technique) """
function find!(parent::Vector{Int}, i::Int)
    parent[i] == i && return i
    result = find!(parent, parent[i])
    parent[i] = result # Path compression
    return result
end

""" A function that performs union __by rank__ of two sets x and y """
function union_set!(parent::Vector{Int}, rank::Vector{Int}, x, y)
    x_root = find!(parent, x)
    y_root = find!(parent, y)
    # Attach smaller rank tree under root of high rank tree
    if rank[x_root] < rank[y_root]
        parent[x_root] = y_root
    elseif rank[x_root] > rank[y_root]
        parent[y_root] = x_root
    else
        # If ranks are the same, make one as root and increment its rank
        parent[y_root] = x_root
        rank[x_root] += 1
    end
end

""" The main function to construct MST using Boruvka's algorithm """
function boruvka_mst!(g::Graph, adjust = true)
    parent = collect(1:g.v)
    rank = zeros(Int, g.v)
    # Initially there are V different trees
    # Finally there will be one tree that will be the MST
    num_trees = g.v
    mst_weight = 0
    # Keep combining components (or sets) until all
    # components are combined into a single MST
    while num_trees > 1
        # An array to store the index of the cheapest edge of each subset
        # It stores [u, v, w] for each component
        cheapest = fill((-1, -1, -1), g.v)
        # Traverse through all edges and update
        # cheapest edge for every component
        for (u, v, w) in g.graph
            set1 = find!(parent, u)
            set2 = find!(parent, v)
            # If two corners of current edge belong to different sets,
            # check if current edge is cheaper than previous cheapest edges
            if set1 != set2
                if cheapest[set1][begin+2] == -1 || cheapest[set1][begin+2] > w
                    cheapest[set1] = (u, v, w)
                end
                if cheapest[set2][begin+2] == -1 || cheapest[set2][begin+2] > w
                    cheapest[set2] = (u, v, w)
                end
            end
        end
        # Consider the picked cheapest edges and add them to the MST
        for vtx in 1:g.v
            # Check if cheapest edge for current set exists
            if cheapest[vtx][begin+2] != -1
                u, v, w = cheapest[vtx]
                set1 = find!(parent, u)
                set2 = find!(parent, v)
                if set1 != set2
                    mst_weight += w
                    union_set!(parent, rank, set1, set2)
                    # adjust vertex numbers in output to match original edge array basis of 0
                    println("Edge $(u-adjust)->$(v-adjust) with weight $w is included in MST")
                    num_trees -= 1
                end
            end
        end
        println("Weight of MST is ", mst_weight)
    end
end

function test_mst()
    g = Graph(4)
    add_edge!(g, 0, 1, 10)
    add_edge!(g, 0, 2, 6)
    add_edge!(g, 0, 3, 5)
    add_edge!(g, 1, 3, 15)
    add_edge!(g, 2, 3, 4)
    boruvka_mst!(g)
end

test_mst()
