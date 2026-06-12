from itertools import combinations

def held_karp(dist):
    """
    Solve the Traveling Salesman Problem using the Held–Karp algorithm.
    dist: a 2D square matrix (list of lists) of pairwise distances.
    Returns (min_cost, tour) where tour is a list of node indices, starting
    and ending at 0.
    """
    n = len(dist)
    # Number of subsets: 2^n
    N = 1 << n
    INF = float('inf')

    # dp[mask][j] = minimum cost to reach subset 'mask' and end at node j
    dp = [[INF] * n for _ in range(N)]
    # parent[mask][j] = previous node before j in optimal path for (mask, j)
    parent = [[None] * n for _ in range(N)]

    # Base case: start at node 0, mask = 1<<0
    dp[1][0] = 0

    # Iterate over all subsets that include node 0
    for mask in range(1, N):
        if not (mask & 1):
            continue  # we always require the tour to start at node 0
        for j in range(1, n):
            if not (mask & (1 << j)):
                continue  # j not in subset
            prev_mask = mask ^ (1 << j)
            # Try all possibilities of coming to j from some k in prev_mask
            for k in range(n):
                if prev_mask & (1 << k):
                    cost = dp[prev_mask][k] + dist[k][j]
                    if cost < dp[mask][j]:
                        dp[mask][j] = cost
                        parent[mask][j] = k

    # Close the tour: return to node 0
    full_mask = (1 << n) - 1
    min_cost = INF
    last = None
    for j in range(1, n):
        cost = dp[full_mask][j] + dist[j][0]
        if cost < min_cost:
            min_cost = cost
            last = j

    # Reconstruct path
    path = []
    mask = full_mask
    curr = last
    while curr is not None:
        path.append(curr)
        prev = parent[mask][curr]
        mask ^= (1 << curr)
        curr = prev
    path.append(0)            # add the start node
    path.reverse()            # reverse to get 0 -> ... -> last
    path.append(0)            # and return to 0

    return min_cost, path

if __name__ == "__main__":
    # Example test case: 4 cities, symmetric distances
    dist_matrix = [
        [0,  2,  9, 10],
        [1,  0,  6,  4],
        [15, 7,  0,  8],
        [6,  3, 12,  0]
    ]

    cost, tour = held_karp(dist_matrix)
    print("Minimum tour cost:", cost)
    print("Tour:", tour)
