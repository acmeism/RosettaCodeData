/**
 * Solve the Traveling Salesman Problem using the Held–Karp algorithm (O(n^2·2^n)).
 * @param {number[][]} dist  – an n×n matrix of pairwise distances
 * @returns {{ cost: number, tour: number[] }}
 *    cost: minimum tour cost
 *    tour: list of city indices starting and ending at 0
 */
function heldKarp(dist) {
  const n = dist.length;
  const subsetCount = 1 << n;
  const INF = Infinity;

  // dp[mask][j] = minimum cost to start at 0, visit exactly the cities in mask, and end at j
  const dp = Array.from({ length: subsetCount }, () => Array(n).fill(INF));
  // parent[mask][j] = best predecessor of j in the optimal path for (mask, j)
  const parent = Array.from({ length: subsetCount }, () => Array(n).fill(-1));

  // Base case: mask = 1<<0, at city 0, cost = 0
  dp[1][0] = 0;

  // Build up dp table
  for (let mask = 1; mask < subsetCount; mask++) {
    // City 0 must always be included
    if ((mask & 1) === 0) continue;

    for (let j = 1; j < n; j++) {
      if ((mask & (1 << j)) === 0) continue;
      const prevMask = mask ^ (1 << j);
      // Try to come to j from some k in prevMask
      for (let k = 0; k < n; k++) {
        if ((prevMask & (1 << k)) === 0) continue;
        const cost = dp[prevMask][k] + dist[k][j];
        if (cost < dp[mask][j]) {
          dp[mask][j] = cost;
          parent[mask][j] = k;
        }
      }
    }
  }

  // Close the tour by returning to city 0
  const fullMask = subsetCount - 1;
  let minCost = INF;
  let lastCity = 0;
  for (let j = 1; j < n; j++) {
    const cost = dp[fullMask][j] + dist[j][0];
    if (cost < minCost) {
      minCost = cost;
      lastCity = j;
    }
  }

  // Reconstruct the optimal tour
  const tour = [];
  let mask = fullMask;
  let curr = lastCity;
  while (curr !== 0) {
    tour.push(curr);
    const p = parent[mask][curr];
    mask ^= 1 << curr;
    curr = p;
  }
  tour.push(0);
  tour.reverse();
  tour.push(0);

  return { cost: minCost, tour };
}

// -- Example usage:

const dist = [
  [ 0,  2,  9, 10 ],
  [ 1,  0,  6,  4 ],
  [15,  7,  0,  8 ],
  [ 6,  3, 12,  0 ]
];

const { cost, tour } = heldKarp(dist);
console.log("Minimum tour cost:", cost);
console.log("Tour:", tour);
