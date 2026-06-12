"use strict";

class Graph {
  constructor(n) {
    // Create a new graph on n vertices (0..n-1), no edges.
    this.n = n;
    this.adj = Array.from({ length: n }, () => Array(n).fill(false));
  }

  clone() {
    // Return a deep copy of the graph.
    const g2 = new Graph(this.n);
    g2.adj = this.adj.map(row => row.slice());
    return g2;
  }

  addEdge(u, v) {
    // Add an undirected edge u--v.
    if (u < 0 || u >= this.n || v < 0 || v >= this.n) {
      throw new RangeError("vertex index out of bounds");
    }
    this.adj[u][v] = true;
    this.adj[v][u] = true;
  }

  degree(u) {
    // Degree of vertex u.
    return this.adj[u].reduce((sum, hasEdge) => sum + (hasEdge ? 1 : 0), 0);
  }

  closure() {
    // Compute the Chvátal closure in-place.
    const n = this.n;
    while (true) {
      let added = false;
      outer:
      for (let u = 0; u < n; u++) {
        for (let v = u + 1; v < n; v++) {
          if (!this.adj[u][v]) {
            if (this.degree(u) + this.degree(v) >= n) {
              this.addEdge(u, v);
              added = true;
              break outer;
            }
          }
        }
      }
      if (!added) break;
    }
  }

  isComplete() {
    // Is the graph complete?
    for (let u = 0; u < this.n; u++) {
      for (let v = u + 1; v < this.n; v++) {
        if (!this.adj[u][v]) return false;
      }
    }
    return true;
  }

  hamiltonianCycle() {
    // Find a Hamiltonian cycle by simple backtracking.
    const n = this.n;
    const visited = Array(n).fill(false);
    const path = [0];
    visited[0] = true;

    const dfs = (u) => {
      if (path.length === n) {
        // Can we close the cycle?
        if (this.adj[u][path[0]]) {
          return path.concat(path[0]);
        }
        return null;
      }
      for (let v = 0; v < n; v++) {
        if (!visited[v] && this.adj[u][v]) {
          visited[v] = true;
          path.push(v);
          const cycle = dfs(v);
          if (cycle) return cycle;
          // backtrack
          path.pop();
          visited[v] = false;
        }
      }
      return null;
    };

    return dfs(0);
  }
}

// --- Main ---

// Example: 5 vertices, almost complete graph missing edge 0--1.
// This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
const g = new Graph(5);
// Add all edges except (0,1)
for (let u = 0; u < 5; u++) {
  for (let v = u + 1; v < 5; v++) {
    if (!(u === 0 && v === 1)) {
      g.addEdge(u, v);
    }
  }
}

console.log("Original graph degrees:");
for (let u = 0; u < g.n; u++) {
  console.log(` deg(${u}) = ${g.degree(u)}`);
}

// Compute closure
const closure = g.clone();
closure.closure();

console.log("\nAfter Chvátal closure:");
for (let u = 0; u < closure.n; u++) {
  let neighbors = [];
  for (let v = 0; v < closure.n; v++) {
    if (closure.adj[u][v]) neighbors.push(v);
  }
  console.log(`  ${u}: ${neighbors.join(" ")}`);
}

if (closure.isComplete()) {
  console.log("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).");
  const cycle = g.hamiltonianCycle();
  if (cycle) {
    console.log("Found Hamiltonian cycle in original graph:");
    console.log(cycle.join(" → "));
  } else {
    console.log("Unexpected: could not find a Hamiltonian cycle.");
  }
} else {
  console.log("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.");
}
