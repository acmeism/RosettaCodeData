"""
Note that because Julia's arrays are 1-based, the 1-based algorithm used
in the original posting works more naturally under Julia as a 2-based algorithm.
Hard coded edges in the tests have been adjusted accordingly.
"""

using DataStructures

const NIL = 1
const INF = typemax(Int)

"""
Implementation of the Hopcroft-Karp algorithm for finding maximum matching
in a bipartite graph.

Assumes vertices in the left partition (U) are numbered 2 to m+1,
and vertices in the right partition (V) are numbered 2 to n+1.
The NIL node is represented by 1.
"""
mutable struct HKGraph
    m::Int
    n::Int
    adj::Vector{Vector{Int}}
    pair_u::Vector{Int}
    pair_v::Vector{Int}
    dist::Vector{Int}
end
"""
Constructor for the HKGraph class.
Arguments:
    m (int): Number of vertices in the left partition (U).
    n (int): Number of vertices in the right partition (V).
"""
function HKGraph(m, n)
    pair_u = fill(NIL, m + 1)
    pair_v = fill(NIL, n + 1)
    dist = fill(INF, m + 1)
    return HKGraph(m, n, [Int[] for _ in 1:m+1], pair_u, pair_v, dist)
end

"""
Adds a directed edge from vertex u (left partition) to vertex v (right partition).
Arguments:
    u (int): Vertex index in the left partition (2 to m+1).
    v (int): Vertex index in the right partition (2 to n+1).
"""
function add_edge!(g::HKGraph, u, v)
    # Ensure vertices are within the valid range
    if 2 <= u <= g.m+1 && 2 <= v <= g.n+1
        push!(g.adj[u], v)  # Add v to u's adjacency list
    else
        @warn "Attempted to add edge ({u}, {v}) outside graph bounds [2..$(g.m+1)], [2..$(g.n+1)]"
    end
end

"""
Performs Breadth-First Search (BFS) to find layers in the graph.
It checks if there exists an augmenting path starting from a free vertex in U.
Returns:
    bool: True if an augmenting path might exist (dist[NIL] is finite),
          False otherwise.
"""
function bfs(g::HKGraph)::Bool
    queue = Deque{Int}()
    # Initialize distances for vertices in U
    for u in 2:g.m+1
        if g.pair_u[u] == NIL
            # If u is a free vertex, its distance is 0, add to queue
            g.dist[u] = 0
            push!(queue, u)
        else
            # Otherwise, set distance to infinity initially
            g.dist[u] = INF
        end
    end
    # Distance to the NIL node represents the length of the shortest augmenting path
    g.dist[NIL] = INF
    while !isempty(queue)
        u = popfirst!(queue)  # Dequeue a vertex from U
        # If the path through u can potentially lead to a shorter augmenting path
        if g.dist[u] < g.dist[NIL]
            # Explore neighbors v of u in V
            for v in g.adj[u]
                matched_u = g.pair_v[v]  # Get the vertex u' matched with v
                # If the matched vertex u' hasn't been visited yet (its distance is INF)
                if g.dist[matched_u] == INF
                    # Set the distance of u' based on u
                    g.dist[matched_u] = g.dist[u] + 1
                    # Enqueue u' to explore further
                    push!(queue, matched_u)
                end
            end
        end
    end
    # INIL is still INF, no augmenting path was found originating
    # from the initial free vertices. Otherwise, augmenting paths might exist.
    return g.dist[NIL] != INF
end

"""
Performs Depth-First Search (DFS) starting from vertex u in U
to find and augment along a shortest path identified by BFS.
Arguments:
    u (int): The current vertex in U being visited (oNIL).
Returns:
    bool: True if an augmenting path was found and used starting from u,
          False otherwise.
"""
function dfs(g::HKGraph, u)::Bool
    if u != NIL
        # Explore neighbors v of u in V
        for v in g.adj[u]
            matched_u = g.pair_v[v]  # Get the vertex u' matched with v
            # Check if the edge (u, v) leads to a vertex u'
            # such that the path u -> v -> u' is part of a shortest augmenting path
            if g.dist[matched_u] == g.dist[u] + 1
                # Recursively call DFS on u'
                if dfs(g, matched_u)
                    # If an augmenting path is found starting from u',
                    # update the matching: match v with u, and u with v
                    g.pair_v[v] = u
                    g.pair_u[u] = v
                    return true  # Augmentation successful
                end
            end
        end
        # If no augmenting path was found starting from u through any neighbor v,
        # mark u as visited in this DFS phase by setting its distance to INF
        g.dist[u] = INF
        return false  # Augmentation failed for this path
    end
    # Base case: If u iNIL, it means we have reached the end of an alternating path
    # originating from a free vertex in U and ending at a free vertex in V (represented bNIL).
    return true
end

"""
Executes the Hopcroft-Karp algorithm to find the maximum matching.

Returns:
    int: The size of the maximum matching found.
"""
function hopcroft_karp_algorithm(g)::Int
    # Initialize matching pairs tNIL (unmatched)
    g.pair_u = fill(NIL, g.m + 1)
    g.pair_v = fill(NIL, g.n + 1)
    matching_size = 0  # Initialize the size of the matching

    # Keep finding augmenting paths using BFS and DFS until no more exist
    while bfs(g)
        # For every free vertex u in U
        for u in 2:g.m+1
            # If u is free and an augmenting path starting from u is found via DFS
            if g.pair_u[u] == NIL && dfs(g, u)
                # Increment the matching size
                matching_size += 1
            end
        end
    end
    return matching_size
end

# --- Testing ---

""" Runs test cases for the Hopcroft-Karp implementation. """
function hk_g_tests()
    println("Running tests...")
    # Test Case 1
    # m=3, n=5, edges = [(1+1, 4+1)] - 2 based indices, expected matching size = 1
    g1 = HKGraph(3, 5)
    add_edge!(g1, 1+1, 4+1)
    res1 = hopcroft_karp_algorithm(g1)
    expected_res1 = 1
    println("Test 1: Result=$res1, Expected=$expected_res1")
    @assert res1 == expected_res1 "Test 1 Failed: Expected $expected_res1, got $res1"

    # Test Case 2 (changed values to 2 based indices)
    # m=6, n=6, edges = [(1,4), (1,5), (5,1)]
    # Expected matching size = 2 (e.g., (1,4), (5,1) or (1,5), (5,1))
    # Note: Original C++ test had (0,1) and (5,0) which are problematic with 1-based index logic.
    g2 = HKGraph(6, 6)
    add_edge!(g2,1+1, 4+1)
    add_edge!(g2, 1+1, 5+1)
    add_edge!(g2, 5+1, 1+1)  # Assuming (5,0) meant a valid edge like (5,1)
    res2 = hopcroft_karp_algorithm(g2)
    expected_res2 = 2
    println("Test 2: Result=$res2, Expected=$expected_res2")
    @assert res2 == expected_res2 "Test 3 Failed: Expected $expected_res2, got $res2"

    # Test Case 3: Complete Bipartite Graph K_{3,3}
    # m=3, n=3, all possible edges. Expected matching size = 3
    g3 = HKGraph(3, 3)
    for i in 2:4, j in 2:4
        add_edge!(g3, i, j)
    end
    res3 = hopcroft_karp_algorithm(g3)
    expected_res3 = 3
    println("Test 3: Result=$res3, Expected=$expected_res3")
    @assert res3 == expected_res3 "Test 4 Failed: Expected $expected_res3, got $res3"

    # Test Case 4: No edges
    # m=2, n=2, no edges. Expected matching size = 0
    g4 = HKGraph(2, 2)
    res4 = hopcroft_karp_algorithm(g4)
    expected_res4 = 0
    println("Test 4: Result=$res4, Expected=$expected_res4")
    @assert res4 == expected_res4 "Test 4 Failed: Expected $expected_res4, got $res4"

    print("All tests passed!")
end

function all_hk_tests()
    # Run g-tests first
    hk_g_tests()
    println("\n--- Running main execution with hard-coded input ---")

    # --- Hard-coded input data ---
    # Example 1: Corresponds to Test Case 2
    hardcoded_v1 = 4  # Number of vertices in left partition (m)
    hardcoded_v2 = 4  # Number of vertices in right partition (n)
    hardcoded_edges = [
        (2, 2),
        (2, 4),
        (3, 4),
        (4, 5),
        (5, 4),
        (5, 3)
    ]
    # Expected output for Example 1: 3

    # Use the selected hardcoded data
    v1 = hardcoded_v1
    v2 = hardcoded_v2
    edges_data = hardcoded_edges
    e_len = length(edges_data)  # Number of edges is derived from the list

    # Create the graph object
    g = HKGraph(v1, v2)

    println("Hard-coded graph dimensions: m=$v1, n=$v2, edges=$e_len")
    println("Adding hard-coded edges:")

    # Add edges from the hard-coded list
    for (u, v) in edges_data
        println("  Adding edge: 2-based ($u, $v), 1-based ($(u-1), $(v-1)) ")
        # Add edge only if vertices are within valid 2-based range
        if 2 <= u <= v1+1 && 2 <= v <= v2+1
            add_edge!(g, u, v)
        else
            # This warning is important if hardcoded data might be invalid
            println("Warning: Skipping invalid hard-coded edge ($u, $v) - indices out of range [1..$v1] or [1..$v2]")
        end
    end
    # Run the Hopcroft-Karp algorithm
    max_matching_size = hopcroft_karp_algorithm(g)

    # Print the result
    println("Maximum matching size is $max_matching_size")
end

all_hk_tests()
