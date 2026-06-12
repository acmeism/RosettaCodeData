use std::collections::VecDeque;
use std::u32;

/// Representation of a bipartite graph.
/// Vertices in the left partition, U, are numbered from 1 to m,
/// and vertices in the right partition, V, are numbered 1 to n.
struct BipartiteGraph {
    adjacency_lists: Vec<Vec<u32>>, // adjacency_lists(u) stores a list of neighbours of u in V
    pair_u: Vec<u32>, // pair_u(u) stores the vertex v in V matched with u in U, or NIL if unmatched
    pair_v: Vec<u32>, // pair_v(v) stores the vertex u in U matched with v in V, or NIL if unmatched
    levels: Vec<u32>, // levels(u) stores the level of vertex u in U during a breadth first search
    m: u32, // Index of the vertices in the left partition
    n: u32, // Index of the vertices in the right partition
    nil: u32,
    infinity: u32,
}

impl BipartiteGraph {
    fn new(m: u32, n: u32) -> Self {
        let nil = 0;
        let infinity = u32::MAX;

        let mut adjacency_lists = Vec::with_capacity((m + 1) as usize);
        for _ in 0..=m {
            adjacency_lists.push(Vec::new());
        }

        let pair_u = vec![nil; (m + 1) as usize];
        let pair_v = vec![nil; (n + 1) as usize];
        let levels = vec![infinity; (m + 1) as usize];

        BipartiteGraph {
            adjacency_lists,
            pair_u,
            pair_v,
            levels,
            m,
            n,
            nil,
            infinity,
        }
    }

    fn add_edge(&mut self, u: u32, v: u32) -> Result<(), String> {
        if 1 <= u && u <= self.m && 1 <= v && v <= self.n {
            self.adjacency_lists[u as usize].push(v);
            Ok(())
        } else {
            Err(format!("Attempt to add an edge ({}, {}) which is out of bounds", u, v))
        }
    }

    /// Return the matching size of the bipartite graph.
    fn hopcroft_karp_algorithm(&mut self) -> u32 {
        self.pair_u = vec![self.nil; (self.m + 1) as usize];
        self.pair_v = vec![self.nil; (self.n + 1) as usize];
        let mut matching_size = 0;

        while self.breadth_first_search() {
            for u in 1..=self.m {
                // vertex u is free and an augmenting path starting
                // from u has been found by the depth first search
                if self.pair_u[u as usize] == self.nil && self.depth_first_search(u) {
                    matching_size += 1;
                }
            }
        }
        matching_size
    }

    /// Determines whether there exists an augmenting path starting from a free vertex in U.
    ///
    /// Return true if an augmenting path could exist, otherwise false.
    fn breadth_first_search(&mut self) -> bool {
        let mut queue = VecDeque::new();

        // Initialize 'levels' for the vertices in U
        for u in 1..=self.m {
            if self.pair_u[u as usize] == self.nil {
                // If u is a free vertex, its level is 0 and it is added to the queue
                self.levels[u as usize] = 0;
                queue.push_back(u);
            } else {
                // Otherwise, set 'levels' to infinity
                self.levels[u as usize] = self.infinity;
            }
        }

        // The 'level' to the NIL node represents the length of the shortest augmenting path
        self.levels[self.nil as usize] = self.infinity;

        while !queue.is_empty() {
            let u = queue.pop_front().unwrap();

            // The path through u could lead to a shorter augmenting path
            if self.levels[u as usize] < self.levels[self.nil as usize] {
                // Explore the neighbours v of u in V
                for &v in &self.adjacency_lists[u as usize] {
                    let matched_u = self.pair_v[v as usize];

                    // The matched vertex has not been visited yet
                    if self.levels[matched_u as usize] == self.infinity {
                        self.levels[matched_u as usize] = self.levels[u as usize] + 1;
                        // Enqueue the matched vertex to explore it further
                        queue.push_back(matched_u);
                    }
                }
            }
        }

        // An augmenting path from the initial free vertices was found if levels[NIL] is not INFINITY
        self.levels[self.nil as usize] != self.infinity
    }

    /// Determine whether the shortest path from vertex u in U found by breadth_first_search() can be augmented.
    ///
    /// Return true if an augmenting path was found starting from u, otherwise false.
    fn depth_first_search(&mut self, u: u32) -> bool {
        if u != self.nil {
            // Explore neighbours v of u in V
            for &v in &self.adjacency_lists[u as usize].clone() {
                let matched_u = self.pair_v[v as usize];

                // Check whether the edge (u, v) leads to a vertex matched_u
                // such that the path u -> v -> matched_u is part of a shortest augmenting path
                if self.levels[matched_u as usize] == self.levels[u as usize] + 1 {
                    // An augmenting path is found starting from 'matched_u'
                    if self.depth_first_search(matched_u) {
                        // Match v with u and u with v
                        self.pair_v[v as usize] = u;
                        self.pair_u[u as usize] = v;
                        return true;
                    }
                }
            }

            // No augmenting path was found starting from vertex u through any of its neighbours v,
            // so remove u from the depth first search phase of the algorithm
            self.levels[u as usize] = self.infinity;
            false
        } else {
            true
        }
    }
}

struct Edge {
    from: u32,
    to: u32,
}

fn test_value(test_number: u32, m: u32, n: u32, edges: &[Edge], expected_result: u32) -> u32 {
    let mut graph = BipartiteGraph::new(m, n);

    for edge in edges {
        if let Err(e) = graph.add_edge(edge.from, edge.to) {
            println!("{}", e);
            return 0;
        }
    }

    let result = graph.hopcroft_karp_algorithm();
    println!("Test {}: Result = {}, Expected = {}", test_number, result, expected_result);

    if result == expected_result {
        1
    } else {
        println!("Test {} failed.", test_number);
        0
    }
}

fn main() {
    println!("Running tests:");
    let mut success_count = 0;

    // Test Case 1
    success_count += test_value(1, 3, 5, &[Edge { from: 1, to: 4 }], 1);

    // Test Case 2
    success_count += test_value(2, 6, 6, &[
        Edge { from: 1, to: 4 },
        Edge { from: 1, to: 5 },
        Edge { from: 5, to: 1 }
    ], 2);

    // Test Case 3: Complete Bipartite Graph K(3, 3)
    let mut edges = Vec::new();
    for i in 1..=3 {
        for j in 1..=3 {
            edges.push(Edge { from: i, to: j });
        }
    }
    success_count += test_value(3, 3, 3, &edges, 3);

    // Test Case 4: No edges
    success_count += test_value(4, 2, 2, &[], 0);

    // Test Case 5
    let edges = vec![
        Edge { from: 1, to: 1 },
        Edge { from: 1, to: 3 },
        Edge { from: 2, to: 3 },
        Edge { from: 3, to: 4 },
        Edge { from: 4, to: 3 },
        Edge { from: 4, to: 2 }
    ];
    success_count += test_value(5, 4, 4, &edges, 4);

    if success_count == 5 {
        println!("All tests passed.");
    }
}
