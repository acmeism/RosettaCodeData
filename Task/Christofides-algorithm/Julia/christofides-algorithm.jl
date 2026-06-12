using Random

""" Helper Structs """
struct Point
    x::Float64
    y::Float64
    id::Int # Original index
end
struct Edge
    u::Int
    v::Int
    weight::Float64
end

""" Helper Function to print vectors/lists """
print_container(container, name, zerobase = true) = println("$name: $(container .- zerobase)")

""" Helper Function to print graph edges """
function print_edges(edges, name, zerobase = true)
    print("$name: [")
    for (i, edge) in enumerate(edges)
        u, v = edge.u - zerobase, edge.v - zerobase
        1 < i < lastindex(edges) && print(", ")
        print("($u, $v, $(round(edge.weight, digits=2)))")
    end
    println("]")
end

""" Helper Function to print graph """
function print_graph(graph, name, zerobase = true)
    println("$name: {")
    n = length(graph)
    for i in 1:n
        print("  $(i - zerobase): {")
        first = true
        for j in 1:n
            if i != j
                !first && print(", ")
                print("$(j - zerobase): ", round(graph[i][j], digits = 2))
                first = false
            end
        end
        println("]", i == n ? "" : ",")
    end
    println("}")
end

""" Euclidean Distance """
get_length(p1, p2) = sqrt((p1.x - p2.x)^2 + (p1.y - p2.y)^2)

""" Build Complete Graph (Adjacency Matrix) """
function build_graph(data)
    n = length(data)
    graph = zeros(n, n)
    for i in 1:n
        for j in i+1:n # Only calculate upper triangle + diagonal is 0
            dist = get_length(data[i], data[j])
            graph[i, j] = dist
            graph[j, i] = dist # Symmetric graph
        end
    end
    return graph
end

""" Union-Find Data Structure """
struct UnionFind
    parent::Vector{Int}
    rank::Vector{Int}
end
UnionFind(n) = UnionFind(collect(1:n), zeros(Int, n))

""" find a point in structure """
function find(uf::UnionFind, i)
    uf.parent[i] == i && return i
    # Path compression
    uf.parent[i] = find(uf, uf.parent[i])
    return uf.parent[i]
end

function unite(uf::UnionFind, i, j)
    rootI = find(uf, i)
    rootJ = find(uf, j)
    if rootI != rootJ
        # Union by rank
        if uf.rank[rootI] < uf.rank[rootJ]
            uf.parent[rootI] = rootJ
        elseif uf.rank[rootI] > uf.rank[rootJ]
            uf.parent[rootJ] = rootI
        else
            uf.parent[rootJ] = rootI
            uf.rank[rootI] += 1
        end
    end
end

""" Minimum Spanning Tree (Kruskal's Algorithm) """
function minimum_spanning_tree(graph)
    n = size(graph, 1)
    n == 0 && return Edge[]
    edges = [Edge(i, j, graph[i, j]) for i in 1:n for j in i+1:n]
    # Sort edges by weight
    sort!(edges, by = ed -> ed.weight)

    mst = Edge[]
    uf = UnionFind(n)
    edges_count = 0
    for edge in edges
        if find(uf, edge.u) != find(uf, edge.v)
            push!(mst, edge)
            unite(uf, edge.u, edge.v)
            edges_count += 1
            edges_count == n - 1 && break # Optimization: MST has n-1 edges
        end
    end
    return mst
end

""" Find Vertices with Odd Degree in MST """
function find_odd_vertices(mst, n)
    degree = zeros(Int, n)
    for edge in mst
        degree[edge.u] += 1
        degree[edge.v] += 1
    end
    return filter(i -> isodd(degree[i]), 1:n)
end

""" Minimum Weight Matching (Greedy Heuristic) """
function minimum_weight_matching!(mst, graph, odd_vertices)
    # Create a copy to allow modification while iterating, shuffle for randomness
    current_odd = shuffle(odd_vertices)

    # Keep track of vertices already matched in this phase
    matched = falses(length(graph))

    for (i, v) in enumerate(current_odd)
        matched[v] && continue # Skip if already matched
        min_length = typemax(Int)
        closest_u = -1

        # Find the closest unmatched odd vertex
        for j in i+1:lastindex(current_odd)
            u = current_odd[j]
            if !matched[u] # Check if 'u' is available
                if graph[v, u] < min_length
                    min_length = graph[v, u]
                    closest_u = u
                end
            end
        end

        if closest_u != -1
            # Add the matching edge to the MST list (now a multigraph)
            push!(mst, Edge(v, closest_u, min_length)) # nb: modifies mst
            matched[v] = true
            matched[closest_u] = true # Mark both as matched
        end
    end
    # Note: In a perfect matching on an even number of vertices,
    # every vertex should find a match. If closest_u remains -1,
    # something is wrong (e.g., odd number of odd_vertices input?)
    # Christofides guarantees an even number of odd-degree vertices.
    return mst
end

struct EdgeInfo
    neighbor::Int
    edge::Edge
    EdgeInfo(i = 0, edg = Edge(0, 0, 0.0)) = new(i, edg)
end

""" Find Eulerian Tour (Hierholzer's Algorithm) """
function find_eulerian_tour(matched_mst, n)
    isempty(matched_mst) && return Int[]

    # Build adjacency list representation of the multigraph (MST + matching)
    adj = [EdgeInfo[] for _ in 1:n]
    edge_used = Dict{Edge, Bool}()

    for edge in matched_mst
        push!(adj[edge.u], EdgeInfo(edge.v, edge))
        push!(adj[edge.v], EdgeInfo(edge.u, edge))
        edge_used[edge] = false
    end

    tour = Int[]
    current_path = Int[]

    # Start at any vertex with edges (e.g., the first vertex of the first edge)
    start_node = matched_mst[begin].u
    push!(current_path, start_node)

    while !isempty(current_path)
        current_node = current_path[end]
        found_edge = false
        # Find an unused edge from the current node
        for i in eachindex(adj[current_node])
            neighbor = adj[current_node][i].neighbor
            edge_ptr = adj[current_node][i].edge

            if !edge_used[edge_ptr]
                edge_used[edge_ptr] = true # Mark edge as used
                # Push neighbor onto stack and move to it
                push!(current_path, neighbor)
                found_edge = true
                break # Move to the neighbor
            end
        end
        # If no unused edge was found from currentNode, backtrack
        if !found_edge
            push!(tour, pop!(current_path))
        end
    end
    # Reverse the tour
    return reverse!(tour)
end

""" Main TSP Function (Christofides Approximation) """
function tsp(data)
    n = length(data)
    n == 0 && return 0.0, Int[]
    n == 1 && return 0.0, [data[begin].id]

    # Build a graph
    g = build_graph(data)
    ms_tree = minimum_spanning_tree(g)
    print_edges(ms_tree, "MSTree")

    # Find odd degree vertices
    odd_vertexes = find_odd_vertices(ms_tree, n)
    print_container(odd_vertexes, "Odd vertexes in MSTree")

    # Add minimum weight matching edges (using greedy heuristic)
    # As in the C++ example, this modifies the mst by adding extra edges
    minimum_weight_matching!(ms_tree, g, odd_vertexes)
    print_edges(ms_tree, "Minimum weight matching (MST + Matching Edges)")

    # Find an Eulerian tour in the combined graph
    eulerian_tour = find_eulerian_tour(ms_tree, n)
    print_container(eulerian_tour, "Eulerian tour")

    # --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    if isempty(eulerian_tour)
        println("Error: Eulerian tour could not be found.")
        return -1.0, Int[]
    end

    path = Int[]
    len = 0.0
    visited = falses(n)

    current = eulerian_tour[begin]
    push!(path, current)
    visited[current] = true

    for v in eulerian_tour
        if !visited[v]
            push!(path, v)
            visited[v] = true
            len += g[current, v] # Add distance from previous node in path
            current = v             # Update current node in path
        end
    end

    # Add the edge back to the start
    len += g[current, path[begin]]
    push!(path, path[begin]) # Complete the cycle

    print_container(path, "Result path")
    println("Result length of the path: ", round(len, digits = 2))

    return len, path
end

# Input data matching the C++ example
const RAW_DATA = [
    (1380, 939), (2848, 96), (3510, 1671), (457, 334), (3888, 666), (984, 965), (2721, 1482), (1286, 525),
    (2716, 1432), (738, 1325), (1251, 1832), (2728, 1698), (3815, 169), (3683, 1533), (1247, 1945), (123, 862),
    (1234, 1946), (252, 1240), (611, 673), (2576, 1676), (928, 1700), (53, 857), (1807, 1711), (274, 1420),
    (2574, 946), (178, 24), (2678, 1825), (1795, 962), (3384, 1498), (3520, 1079), (1256, 61), (1424, 1728),
    (3913, 192), (3085, 1528), (2573, 1969), (463, 1670), (3875, 598), (298, 1513), (3479, 821), (2542, 236),
    (3955, 1743), (1323, 280), (3447, 1830), (2936, 337), (1621, 1830), (3373, 1646), (1393, 1368),
    (3874, 1318), (938, 955), (3022, 474), (2482, 1183), (3854, 923), (376, 825), (2519, 135), (2945, 1622),
    (953, 268), (2628, 1479), (2097, 981), (890, 1846), (2139, 1806), (2421, 1007), (2290, 1810), (1115, 1052),
    (2588, 302), (327, 265), (241, 341), (1917, 687), (2991, 792), (2573, 599), (19, 674), (3911, 1673),
    (872, 1559), (2863, 558), (929, 1766), (839, 620), (3893, 102), (2178, 1619), (3822, 899), (378, 1048),
    (1178, 100), (2599, 901), (3416, 143), (2961, 1605), (611, 1384), (3113, 885), (2597, 1830), (2586, 1286),
    (161, 906), (1429, 134), (742, 1025), (1625, 1651), (1187, 706), (1787, 1009), (22, 987), (3640, 43),
    (3756, 882), (776, 392), (1724, 1642), (198, 1810), (3950, 1558),
]
const POINTS = [Point(x, y, w) for (w, (x, y)) in enumerate(RAW_DATA)]

tsp(POINTS)
