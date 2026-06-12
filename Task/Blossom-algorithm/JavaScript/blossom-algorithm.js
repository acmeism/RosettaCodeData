class Blossom {
  constructor(adj) {
    this.n = adj.length;
    this.adj = adj;
    this.match = new Array(this.n).fill(-1);
    this.p = new Array(this.n).fill(-1);
    this.base = new Array(this.n);
    this.used = new Array(this.n).fill(false);
    this.blossom = new Array(this.n).fill(false);
    this.queue = [];
  }

  // Find least common ancestor of a and b in the alternating forest
  lca(a, b) {
    const usedPath = new Array(this.n).fill(false);
    while (true) {
      a = this.base[a];
      usedPath[a] = true;
      if (this.match[a] === -1) break;
      a = this.p[this.match[a]];
    }
    while (true) {
      b = this.base[b];
      if (usedPath[b]) return b;
      b = this.p[this.match[b]];
    }
  }

  // Mark path from v up to base0, setting parents to x
  markPath(v, base0, x) {
    while (this.base[v] !== base0) {
      const mv = this.match[v];
      this.blossom[this.base[v]] = this.blossom[this.base[mv]] = true;
      this.p[v] = x;
      x = mv;
      v = this.p[x];
    }
  }

  // Try to find an augmenting path from root
  findPath(root) {
    this.used.fill(false);
    this.p.fill(-1);
    for (let i = 0; i < this.n; i++) {
      this.base[i] = i;
    }
    this.queue = [];

    this.used[root] = true;
    this.queue.push(root);

    while (this.queue.length > 0) {
      const v = this.queue.shift();
      for (const u of this.adj[v]) {
        // Skip same base or matched edge
        if (this.base[v] === this.base[u] || this.match[v] === u) {
          continue;
        }
        // Blossom detected
        if (
          u === root ||
          (this.match[u] !== -1 && this.p[this.match[u]] !== -1)
        ) {
          const curbase = this.lca(v, u);
          this.blossom.fill(false);
          this.markPath(v, curbase, u);
          this.markPath(u, curbase, v);
          for (let i = 0; i < this.n; i++) {
            if (this.blossom[this.base[i]]) {
              this.base[i] = curbase;
              if (!this.used[i]) {
                this.used[i] = true;
                this.queue.push(i);
              }
            }
          }
        }
        // Otherwise, extend the alternating tree
        else if (this.p[u] === -1) {
          this.p[u] = v;
          // If u is free, we found an augmenting path
          if (this.match[u] === -1) {
            let cur = u;
            while (cur !== -1) {
              const prev = this.p[cur];
              const next = prev === -1 ? -1 : this.match[prev];
              this.match[cur] = prev;
              this.match[prev] = cur;
              cur = next;
            }
            return true;
          }
          // Enqueue the matched partner
          const mu = this.match[u];
          if (!this.used[mu]) {
            this.used[mu] = true;
            this.queue.push(mu);
          }
        }
      }
    }
    return false;
  }

  // Compute maximum matching; returns [matchArray, size]
  solve() {
    let size = 0;
    for (let v = 0; v < this.n; v++) {
      if (this.match[v] === -1) {
        if (this.findPath(v)) {
          size++;
        }
      }
    }
    return [this.match, size];
  }
}

// Example usage
(function() {
  // 5-cycle: 0–1–2–3–4–0
  const n = 5;
  const edges = [
    [0, 1],
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 0],
  ];
  const adj = Array.from({ length: n }, () => []);
  for (const [u, v] of edges) {
    adj[u].push(v);
    adj[v].push(u);
  }

  const blossom = new Blossom(adj);
  const [match, msize] = blossom.solve();

  console.log(`Maximum matching size: ${msize}`);
  console.log("Matched pairs:");
  const seen = new Set();
  for (let u = 0; u < n; u++) {
    const v = match[u];
    if (v !== -1 && !seen.has(`${v},${u}`)) {
      console.log(`  ${u} – ${v}`);
      seen.add(`${u},${v}`);
    }
  }
})();
