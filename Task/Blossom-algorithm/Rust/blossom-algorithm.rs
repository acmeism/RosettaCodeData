use std::collections::VecDeque;

struct Blossom {
    n: usize,
    adj: Vec<Vec<usize>>,
    matching: Vec<Option<usize>>,  // matching[v] = Some(u) if v–u is matched
    parent: Vec<Option<usize>>,    // parent in the alternating tree
    base: Vec<usize>,              // base[v] = base vertex of blossom containing v
    used: Vec<bool>,               // used[v] = whether v is in the BFS tree
    blossom: Vec<bool>,            // helper array for marking blossoms
    q: VecDeque<usize>,            // BFS queue
}

impl Blossom {
    fn new(adj: Vec<Vec<usize>>) -> Self {
        let n = adj.len();
        Blossom {
            n,
            adj,
            matching: vec![None; n],
            parent: vec![None; n],
            base: (0..n).collect(),
            used: vec![false; n],
            blossom: vec![false; n],
            q: VecDeque::new(),
        }
    }

    // Find least common ancestor of a and b in the forest of alternating tree.
    fn lca(&self, mut a: usize, mut b: usize) -> usize {
        let mut used_path = vec![false; self.n];
        // climb from a
        loop {
            a = self.base[a];
            used_path[a] = true;
            if let Some(ma) = self.matching[a] {
                if let Some(pa) = self.parent[ma] {
                    a = pa;
                    continue;
                }
            }
            break;
        }
        // climb from b until we hit a marked vertex
        loop {
            b = self.base[b];
            if used_path[b] {
                return b;
            }
            if let Some(mb) = self.matching[b] {
                if let Some(pb) = self.parent[mb] {
                    b = pb;
                    continue;
                }
            }
            // In a valid alternating forest this should always terminate
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x.
    fn mark_path(&mut self, mut v: usize, b: usize, mut x: usize) {
        while self.base[v] != b {
            let mv = self.matching[v].unwrap();
            self.blossom[self.base[v]] = true;
            self.blossom[self.base[mv]] = true;
            self.parent[v] = Some(x);
            x = mv;
            v = self.parent[x].unwrap();
        }
    }

    // Try to find an augmenting path starting from root.
    fn find_path(&mut self, root: usize) -> bool {
        // Reset BFS state
        self.used.fill(false);
        self.parent.fill(None);
        for i in 0..self.n {
            self.base[i] = i;
        }
        self.q.clear();

        self.used[root] = true;
        self.q.push_back(root);

        while let Some(v) = self.q.pop_front() {
            // clone neighbors to avoid borrowing self.adj across the BFS loop
            let neighbors = self.adj[v].clone();
            for u in neighbors {
                if self.base[v] == self.base[u] || self.matching[v] == Some(u) {
                    continue;
                }
                // Found a blossom
                if u == root
                    || (self.matching[u].is_some()
                        && self.parent[self.matching[u].unwrap()].is_some())
                {
                    let curbase = self.lca(v, u);
                    self.blossom.fill(false);
                    self.mark_path(v, curbase, u);
                    self.mark_path(u, curbase, v);
                    for i in 0..self.n {
                        if self.blossom[self.base[i]] {
                            self.base[i] = curbase;
                            if !self.used[i] {
                                self.used[i] = true;
                                self.q.push_back(i);
                            }
                        }
                    }
                }
                // Otherwise, try to extend the alternating tree
                else if self.parent[u].is_none() {
                    self.parent[u] = Some(v);
                    // If u is free, we've found an augmenting path
                    if self.matching[u].is_none() {
                        let mut cur = u;
                        while let Some(prev) = self.parent[cur] {
                            let next = self.matching[prev];
                            self.matching[cur] = Some(prev);
                            self.matching[prev] = Some(cur);
                            if let Some(nxt) = next {
                                cur = nxt;
                            } else {
                                break;
                            }
                        }
                        return true;
                    }
                    // Otherwise enqueue the matched partner
                    let mu = self.matching[u].unwrap();
                    if !self.used[mu] {
                        self.used[mu] = true;
                        self.q.push_back(mu);
                    }
                }
            }
        }
        false
    }

    // Main solver: returns (matching, size_of_matching)
    fn solve(&mut self) -> (Vec<Option<usize>>, usize) {
        let mut res = 0;
        for v in 0..self.n {
            if self.matching[v].is_none() && self.find_path(v) {
                res += 1;
            }
        }
        (self.matching.clone(), res)
    }
}

fn main() {
    // Example: 5‑cycle (odd cycle) 0–1–2–3–4–0
    let n = 5;
    let edges = vec![(0,1), (1,2), (2,3), (3,4), (4,0)];
    let mut adj = vec![Vec::new(); n];
    for &(u, v) in &edges {
        adj[u].push(v);
        adj[v].push(u);
    }

    let mut blossom = Blossom::new(adj);
    let (matching, msize) = blossom.solve();

    println!("Maximum matching size: {}", msize);
    println!("Matched pairs:");
    for u in 0..n {
        if let Some(v) = matching[u] {
            if u < v {
                println!("  {} – {}", u, v);
            }
        }
    }
}
