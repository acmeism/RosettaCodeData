#include <bits/stdc++.h>
using namespace std;

/*
 * Solve the Traveling Salesman Problem using the Held–Karp algorithm (O(n^2·2^n)).
 * dist: square matrix of pairwise distances, dist[i][j] is the cost from i to j.
 * Returns a pair (min_cost, tour), where tour is a sequence of node indices
 * starting and ending at 0.
 */
pair<long long, vector<int>> heldKarp(const vector<vector<long long>>& dist) {
    int n = dist.size();
    int N = 1 << n;                     // number of subsets
    const long long INF = LLONG_MAX / 4;

    // dp[mask][j] = min cost to start at 0, visit exactly the cities in mask, and end at j
    vector<vector<long long>> dp(N, vector<long long>(n, INF));
    // parent[mask][j] = best predecessor of j in the optimal path for (mask, j)
    vector<vector<int>> parent(N, vector<int>(n, -1));

    dp[1][0] = 0;  // base case: mask=1<<0, at city 0, cost=0

    // Build up DP table
    for (int mask = 1; mask < N; ++mask) {
        if ((mask & 1) == 0) continue;  // we always include city 0 in the tour
        for (int j = 1; j < n; ++j) {
            if ((mask & (1 << j)) == 0) continue;
            int prevMask = mask ^ (1 << j);
            for (int k = 0; k < n; ++k) {
                if (prevMask & (1 << k)) {
                    long long cost = dp[prevMask][k] + dist[k][j];
                    if (cost < dp[mask][j]) {
                        dp[mask][j] = cost;
                        parent[mask][j] = k;
                    }
                }
            }
        }
    }

    // Close the tour by returning to city 0
    int fullMask = N - 1;
    long long minCost = INF;
    int lastCity = -1;
    for (int j = 1; j < n; ++j) {
        long long cost = dp[fullMask][j] + dist[j][0];
        if (cost < minCost) {
            minCost = cost;
            lastCity = j;
        }
    }

    // Reconstruct the optimal tour
    vector<int> tour;
    int mask = fullMask, cur = lastCity;
    while (cur != -1) {
        tour.push_back(cur);
        int p = parent[mask][cur];
        mask ^= (1 << cur);
        cur = p;
    }
    tour.push_back(0);           // add the start city
    reverse(tour.begin(), tour.end());
    tour.push_back(0);           // return to start

    return {minCost, tour};
}

int main() {
    // Example test case: 4 cities, symmetric distances
    vector<vector<long long>> dist = {
        { 0,  2,  9, 10},
        { 1,  0,  6,  4},
        {15,  7,  0,  8},
        { 6,  3, 12,  0}
    };

    auto [cost, tour] = heldKarp(dist);

    cout << "Minimum tour cost: " << cost << "\n";
    cout << "Tour: ";
    for (int v : tour) {
        cout << v << " ";
    }
    cout << "\n";

    return 0;
}
