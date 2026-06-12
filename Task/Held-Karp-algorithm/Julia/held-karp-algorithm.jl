const INF = typemax(Int32)

"""
Solve the Traveling Salesman Problem using the Held–Karp algorithm.
dist is a 2D square matrix (list of lists) of pairwise distances.
Returns (min_cost, tour) where tour is a list of node indices, starting
and ending at 0.
"""
function heldkarp(dist)
    n = length(dist)
    N = 1 << n # Number of subsets 2^n
    # dp[mask][j] = minimum cost to reach subset 'mask' and end at node j
    dp = [fill(INF, n) for _ in 1:N]
    # parent[mask][j] = previous node before j in optimal path for (mask, j)
    parent = [fill(-1, n) for _ in 1:N]
    dp[begin+1][begin] = 0 # Base case start at node 1 mask = 1<<0

    # Iterate over all subsets that include node 1
    for mask in 1:2:N-1 # NB: zero based mask, but 1 based indexing
        for j in 2:n
            mask & (1 << (j - 1)) == 0 && continue  # j not in subset
            prev_mask = mask ⊻ (1 << (j - 1))
            # Try all possibilities of coming to j from some k in prev_mask
            for k in 1:n
                prev_mask & (1 << (k - 1)) == 0 && continue
                cost = dp[prev_mask+1][k] + dist[k][j]
                if cost < dp[mask+1][j]
                    dp[mask+1][j] = cost
                    parent[mask+1][j] = k - 1
                end
            end
        end
    end
    # Close the tour return to node 1
    full_mask, min_cost, last = N - 1, INF, 0
    for j in 2:n
        cost = dp[full_mask+1][j] + dist[j][begin]
        if cost < min_cost
            min_cost = cost
            last = j - 1
        end
    end
    # Reconstruct path
    path = Int[]
    mask, curr = full_mask, last
    while curr != 0
        push!(path, curr)
        prev = parent[mask+1][curr+1]
        mask ⊻= 1 << curr
        curr = prev
    end
    push!(path, 0)            # add the start node
    reverse!(path)            # reverse to get 0 -> ... -> last
    push!(path, 0)            # and return to 0
    return min_cost, path
end

function test_tour()
    # Example test case 4 cities, symmetric distances
    dist_matrix = [
        [0, 2, 9, 10],
        [1, 0, 6, 4],
        [15, 7, 0, 8],
        [6, 3, 12, 0],
    ]

    cost, tour = heldkarp(dist_matrix)
    println("Minimum tour cost: ", cost)
    println("Tour: ", tour)
end

test_tour()
