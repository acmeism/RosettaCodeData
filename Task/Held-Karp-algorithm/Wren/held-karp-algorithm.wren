/*  Solve the Traveling Salesman Problem using the Held–Karp algorithm.
    dist: a 2D square matrix (list of lists) of pairwise distances.
    Returns (minCost, tour) where tour is a list of node indices, starting
    and ending at 0.
*/
var heldKarp = Fn.new { |dist|
    var n = dist.count
    var N = 1 << n
    var INF = Num.infinity

    // dp[mask][j] = minimum cost to reach subset 'mask' and end at node j
    var dp = List.filled(N, null)
    for (i in 0...N) dp[i] = List.filled(n, INF)

    // parent[mask][j] = previous node before j in optimal path for (mask, j)
    var parent = List.filled(N, null)
    for (i in 0...N) parent[i] = List.filled(n, null)

    // Base case: start at node 0, mask = 1<<0
    dp[1][0] = 0

    // Iterate over all subsets that include node 0.
    for (mask in 1...N) {
        if (mask & 1 == 0) continue  // we always require the tour to start at node 0
        for (j in 1...n) {
            if ((mask & (1 << j)) == 0) continue  // j not in subset
            var prevMask = mask ^ (1 << j)
            // Try all possibilities of coming to j from some k in prevMask
            for (k in 0...n) {
                if ((prevMask & (1 << k)) != 0) {
                    var cost = dp[prevMask][k] + dist[k][j]
                    if (cost < dp[mask][j]) {
                        dp[mask][j] = cost
                        parent[mask][j] = k
                    }
                }
            }
        }
    }

    // Close the tour: return to node 0.
    var fullMask = (1 << n) - 1
    var minCost = INF
    var last = null
    for (j in 1...n) {
        var cost = dp[fullMask][j] + dist[j][0]
        if (cost < minCost) {
            minCost = cost
            last = j
        }
    }

    // Reconstruct path
    var path = []
    var mask = fullMask
    var curr = last
    while (curr) {
        path.add(curr)
        var prev = parent[mask][curr]
        mask = mask ^ (1 << curr)
        curr = prev
    }
    path.add(0)         // add the start node
    path = path[-1..0]  // reverse to get 0 -> ... -> last
    path.add(0)         // and return to 0
    return [minCost, path]
}

// Example test case: 4 cities, symmetric distances
var distMatrix = [
    [0,  2,  9, 10],
    [1,  0,  6,  4],
    [15, 7,  0,  8],
    [6,  3, 12,  0]
]

var ct = heldKarp.call(distMatrix)
System.print("Minimum tour cost: %(ct[0])")
System.print("Tour: %(ct[1]))")
