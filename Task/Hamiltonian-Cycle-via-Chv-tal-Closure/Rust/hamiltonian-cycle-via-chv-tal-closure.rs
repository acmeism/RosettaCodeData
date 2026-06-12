#[derive(Clone)]
struct Graph {
    n: usize,
    adj: Vec<Vec<bool>>,
}

impl Graph {
    /// Create a new graph on n vertices (0..n-1), no edges.
    fn new(n: usize) -> Self {
        Graph {
            n,
            adj: vec![vec![false; n]; n],
        }
    }

    /// Add an undirected edge u--v.
    fn add_edge(&mut self, u: usize, v: usize) {
        assert!(u < self.n && v < self.n);
        self.adj[u][v] = true;
        self.adj[v][u] = true;
    }

    /// Degree of vertex u.
    fn degree(&self, u: usize) -> usize {
        self.adj[u].iter().filter(|&&b| b).count()
    }

    /// Compute the Chvátal closure in‑place.
    fn closure(&mut self) {
        let n = self.n;
        loop {
            let mut added = false;
            // Try every non-edge (u,v) with u < v
            'outer: for u in 0..n {
                for v in (u+1)..n {
                    if !self.adj[u][v] {
                        let du = self.degree(u);
                        let dv = self.degree(v);
                        if du + dv >= n {
                            // add the edge
                            self.add_edge(u, v);
                            added = true;
                            break 'outer;
                        }
                    }
                }
            }
            if !added {
                break;
            }
        }
    }

    /// Is the graph complete?
    fn is_complete(&self) -> bool {
        for u in 0..self.n {
            for v in (u+1)..self.n {
                if !self.adj[u][v] {
                    return false;
                }
            }
        }
        true
    }

    /// Find a Hamiltonian cycle in the original graph (not closure)
    /// by simple backtracking. Returns vertices in order (0..n-1), and back to start.
    fn hamiltonian_cycle(&self) -> Option<Vec<usize>> {
        let n = self.n;
        let mut visited = vec![false; n];
        let mut path = Vec::with_capacity(n);

        // we can fix starting vertex = 0
        visited[0] = true;
        path.push(0);

        fn dfs(
            g: &Graph,
            u: usize,
            visited: &mut [bool],
            path: &mut Vec<usize>,
        ) -> Option<Vec<usize>> {
            let n = g.n;
            if path.len() == n {
                // check if can close the cycle
                if g.adj[u][path[0]] {
                    let mut cycle = path.clone();
                    cycle.push(path[0]);
                    return Some(cycle);
                } else {
                    return None;
                }
            }
            for v in 0..n {
                if !visited[v] && g.adj[u][v] {
                    visited[v] = true;
                    path.push(v);
                    if let Some(cycle) = dfs(g, v, visited, path) {
                        return Some(cycle);
                    }
                    // backtrack
                    path.pop();
                    visited[v] = false;
                }
            }
            None
        }

        dfs(self, 0, &mut visited, &mut path)
    }
}

fn main() {
    // Example: 5 vertices, almost complete graph missing edge 0--1.
    // This satisfies Ore's condition: any non-edge (0,1) has deg(0)=3, deg(1)=3, 3+3>=5.
    let mut g = Graph::new(5);
    // Add all edges except (0,1)
    for u in 0..5 {
        for v in (u+1)..5 {
            if !(u == 0 && v == 1) {
                g.add_edge(u, v);
            }
        }
    }

    println!("Original graph degrees:");
    for u in 0..g.n {
        println!(" deg({}) = {}", u, g.degree(u));
    }

    // Compute closure
    let mut closure = g.clone();
    closure.closure();

    println!("\nAfter Chvátal closure:");
    for u in 0..closure.n {
        print!("  {}:", u);
        for v in 0..closure.n {
            if closure.adj[u][v] {
                print!(" {}", v);
            }
        }
        println!();
    }

    if closure.is_complete() {
        println!("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).");
        if let Some(cycle) = g.hamiltonian_cycle() {
            println!("Found Hamiltonian cycle in original graph:");
            for (i, &v) in cycle.iter().enumerate() {
                if i > 0 { print!(" → "); }
                print!("{}", v);
            }
            println!();
        } else {
            println!("Unexpected: could not find a Hamiltonian cycle.");
        }
    } else {
        println!("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.");
    }
}
