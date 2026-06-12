package main

import (
    "fmt"
    "math"
)

type Result struct {
    Cost int
    Tour []int
}

// heldKarp solves the Traveling Salesman Problem using the Held–Karp algorithm (O(n^2·2^n)).
// dist is an n×n matrix of pairwise distances.
// Returns a Result{minimumCost, tour}, where tour is a sequence of city indices
// starting and ending at 0.
func heldKarp(dist [][]int) Result {
    n := len(dist)
    subsetCount := 1 << n
    const INF = math.MaxInt32 / 4

    // dp[mask][j] = minimum cost to start at 0, visit exactly the cities in mask, and end at j
    dp := make([][]int, subsetCount)
    parents := make([][]int, subsetCount)
    for mask := 0; mask < subsetCount; mask++ {
        dp[mask] = make([]int, n)
        parents[mask] = make([]int, n)
        for j := 0; j < n; j++ {
            dp[mask][j] = INF
            parents[mask][j] = -1
        }
    }

    // Base case: mask = 1<<0, at city 0, cost = 0
    dp[1][0] = 0

    // Build up dp table
    for mask := 1; mask < subsetCount; mask++ {
        // City 0 must always be included
        if mask&1 == 0 {
            continue
        }
        for j := 1; j < n; j++ {
            if mask&(1<<j) == 0 {
                continue
            }
            prevMask := mask ^ (1 << j)
            for k := 0; k < n; k++ {
                if prevMask&(1<<k) == 0 {
                    continue
                }
                cost := dp[prevMask][k] + dist[k][j]
                if cost < dp[mask][j] {
                    dp[mask][j] = cost
                    parents[mask][j] = k
                }
            }
        }
    }

    // Complete the tour by returning to city 0
    fullMask := subsetCount - 1
    minCost := INF
    lastCity := 0
    for j := 1; j < n; j++ {
        cost := dp[fullMask][j] + dist[j][0]
        if cost < minCost {
            minCost = cost
            lastCity = j
        }
    }

    // Reconstruct the optimal tour
    tour := make([]int, 0, n+1)
    mask := fullMask
    curr := lastCity
    for curr != 0 {
        tour = append(tour, curr)
        p := parents[mask][curr]
        mask ^= 1 << curr
        curr = p
    }
    // append the start city, reverse, then return to start
    tour = append(tour, 0)
    reverse(tour)
    tour = append(tour, 0)

    return Result{Cost: minCost, Tour: tour}
}

// reverse reverses a slice of ints in place.
func reverse(a []int) {
    for i, j := 0, len(a)-1; i < j; i, j = i+1, j-1 {
        a[i], a[j] = a[j], a[i]
    }
}

func main() {
    // Test case: 4 cities with symmetric distances
    dist := [][]int{
        {0, 2, 9, 10},
        {1, 0, 6, 4},
        {15, 7, 0, 8},
        {6, 3, 12, 0},
    }

    result := heldKarp(dist)
    fmt.Printf("Minimum tour cost: %d\n", result.Cost)
    fmt.Printf("Tour: %v\n", result.Tour)
}
