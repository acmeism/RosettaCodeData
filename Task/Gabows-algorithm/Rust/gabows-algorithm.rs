use std::fmt;

// Use usize for indices and counts, standard in Rust.
type Vertex = usize;
type ComponentId = usize;

// --- Digraph Struct ---

#[derive(Debug, Clone)] // Added Clone for potential use cases, Debug for easy printing
pub struct Digraph {
    vertex_count: usize,
    edge_count: usize,
    adjacency_lists: Vec<Vec<Vertex>>,
}

impl Digraph {
    /// Creates a new directed graph with a given number of vertices.
    /// Vertices are numbered 0 to vertex_count - 1.
    pub fn new(vertex_count: usize) -> Self {
        Digraph {
            vertex_count,
            edge_count: 0,
            // Initialize adjacency lists: one empty Vec per vertex
            adjacency_lists: vec![Vec::new(); vertex_count],
        }
    }

    /// Adds a directed edge from `from` to `to`.
    ///
    /// # Panics
    /// Panics if `from` or `to` vertex indices are out of bounds.
    pub fn add_edge(&mut self, from: Vertex, to: Vertex) {
        self.validate_vertex(from);
        self.validate_vertex(to);
        self.adjacency_lists[from].push(to);
        self.edge_count += 1;
    }

    /// Returns the number of vertices in the graph.
    pub fn vertex_count(&self) -> usize {
        self.vertex_count
    }

    /// Returns the number of edges in the graph.
    pub fn edge_count(&self) -> usize {
        self.edge_count
    }

    /// Returns a slice representing the adjacency list for a given vertex.
    ///
    /// # Panics
    /// Panics if the vertex index is out of bounds.
    pub fn adjacency_list(&self, vertex: Vertex) -> &[Vertex] {
        self.validate_vertex(vertex);
        &self.adjacency_lists[vertex]
    }

    /// Validates if a vertex index is within the allowed range.
    /// Panics if the vertex is invalid.
    fn validate_vertex(&self, vertex: Vertex) {
        if vertex >= self.vertex_count {
            panic!(
                "Vertex {} is not between 0 and {}",
                vertex,
                self.vertex_count - 1
            );
        }
    }
}

// Implement Display trait for nice printing
impl fmt::Display for Digraph {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        writeln!(
            f,
            "Digraph has {} vertices and {} edges",
            self.vertex_count, self.edge_count
        )?;
        writeln!(f, "Adjacency lists:")?;
        for vertex in 0..self.vertex_count {
            // Format vertex number with padding for alignment
            write!(f, "{:>2}: ", vertex)?;
            // Clone and sort the list for consistent output like the C++ version
            let mut adj_list = self.adjacency_lists[vertex].clone();
            adj_list.sort(); // Sorts in place
            for &adjacent in &adj_list {
                write!(f, "{} ", adjacent)?;
            }
            writeln!(f)?; // Newline after each vertex's list
        }
        Ok(())
    }
}

// --- GabowSCC Struct ---

pub struct GabowScc {
    visited: Vec<bool>,
    // Use Option<ComponentId> instead of a sentinel value like -1/u32::MAX
    component_ids: Vec<Option<ComponentId>>,
    preorders: Vec<Option<usize>>, // Preorder number for each vertex
    preorder_count: usize,         // Counter for assigning preorder numbers
    scc_count: usize,              // Number of strongly connected components found
    // Use Vec as stacks
    visited_vertices_stack: Vec<Vertex>,
    auxiliary_stack: Vec<Vertex>,
}

impl GabowScc {
    /// Computes the strongly connected components of a digraph using Gabow's algorithm.
    pub fn new(digraph: &Digraph) -> Self {
        let n = digraph.vertex_count();
        let mut scc = GabowScc {
            visited: vec![false; n],
            component_ids: vec![None; n],
            preorders: vec![None; n],
            preorder_count: 0,
            scc_count: 0,
            visited_vertices_stack: Vec::new(),
            auxiliary_stack: Vec::new(),
        };

        for vertex in 0..n {
            if !scc.visited[vertex] {
                scc.depth_first_search(digraph, vertex);
            }
        }
        scc
    }

    /// Performs the depth-first search core to Gabow's algorithm.
    fn depth_first_search(&mut self, digraph: &Digraph, vertex: Vertex) {
        self.visited[vertex] = true;
        self.preorders[vertex] = Some(self.preorder_count);
        self.preorder_count += 1;
        self.visited_vertices_stack.push(vertex);
        self.auxiliary_stack.push(vertex);

        for &adjacent in digraph.adjacency_list(vertex) {
            if !self.visited[adjacent] {
                self.depth_first_search(digraph, adjacent);
            } else if self.component_ids[adjacent].is_none() {
                // Adjacent is visited but not yet assigned to an SCC.
                // It must be on the current DFS path or in an already processed SCC
                // within this DFS branch. Check the auxiliary stack.
                let adjacent_preorder = self
                    .preorders[adjacent]
                    .expect("Visited vertex without component ID should have a preorder");

                // Pop vertices from auxiliary_stack until top has preorder <= adjacent's preorder
                while let Some(&top_vertex) = self.auxiliary_stack.last() {
                    let top_preorder = self.preorders[top_vertex]
                        .expect("Vertex on auxiliary stack should have a preorder");
                    if top_preorder > adjacent_preorder {
                        self.auxiliary_stack.pop(); // Pop it
                    } else {
                        break; // Stop popping
                    }
                }
            }
            // If adjacent has a component_id, it belongs to a completed SCC, ignore.
        }

        // Check if 'vertex' is the root of an SCC
        // It's the root if it's still on top of the auxiliary stack here.
        if let Some(&top_vertex) = self.auxiliary_stack.last() {
            if top_vertex == vertex {
                self.auxiliary_stack.pop(); // Pop the root 'vertex' itself

                // Pop vertices from visited_vertices_stack until 'vertex' is found.
                // All these popped vertices form the new SCC.
                loop {
                    let scc_member = self.visited_vertices_stack.pop()
                        .expect("Visited stack should not be empty when forming SCC");
                    self.component_ids[scc_member] = Some(self.scc_count);
                    if scc_member == vertex {
                        break; // Found the root, SCC is complete
                    }
                }
                self.scc_count += 1; // Increment the SCC counter
            }
        }
    }

    /// Returns the total number of strongly connected components found.
    pub fn scc_count(&self) -> usize {
        self.scc_count
    }

    /// Returns the component ID of the SCC containing `vertex`.
    /// Returns `None` if the vertex was unreachable (should not happen in a connected graph analysis).
    ///
    /// # Panics
    /// Panics if the vertex index is out of bounds.
    pub fn get_component_id(&self, vertex: Vertex) -> Option<ComponentId> {
        self.validate_vertex(vertex);
        self.component_ids[vertex] // This is already an Option<ComponentId>
    }

    /// Checks if two vertices `v` and `w` are in the same strongly connected component.
    ///
    /// # Panics
    /// Panics if `v` or `w` vertex indices are out of bounds.
    pub fn is_strongly_connected(&self, v: Vertex, w: Vertex) -> bool {
        self.validate_vertex(v);
        self.validate_vertex(w);
        // Check if both have IDs and if the IDs are the same
        match (self.component_ids[v], self.component_ids[w]) {
            (Some(id_v), Some(id_w)) => id_v == id_w,
            _ => false, // If either vertex doesn't have a component ID, they aren't connected
        }
    }

    /// Returns a vector where each inner vector contains the vertices belonging to one SCC.
    pub fn get_components(&self) -> Vec<Vec<Vertex>> {
        let mut components: Vec<Vec<Vertex>> = vec![Vec::new(); self.scc_count];
        for vertex in 0..self.component_ids.len() {
            if let Some(id) = self.component_ids[vertex] {
                // Ensure the ID is valid before pushing (robustness)
                if id < self.scc_count {
                    components[id].push(vertex);
                } else {
                    // This case indicates an internal logic error
                     eprintln!(
                        "Warning: Vertex {} has an invalid SCC ID {} assigned (max should be {}).",
                        vertex, id, self.scc_count - 1
                     );
                }
            }
            // Vertices with None component_id are ignored (e.g., unreachable)
        }
        // Optionally sort vertices within each component for consistent output
        for component in &mut components {
            component.sort();
        }
        components
    }


    /// Validates if a vertex index is within the bounds based on internal state size.
    /// Panics if the vertex is invalid.
    fn validate_vertex(&self, vertex: Vertex) {
        let visited_count = self.visited.len(); // Use length of internal vectors
        if vertex >= visited_count {
            panic!(
                "Vertex {} is not between 0 and {}",
                vertex,
                 // Handle edge case of 0 vertices gracefully
                if visited_count == 0 { 0 } else { visited_count - 1 }
            );
        }
    }
}


// --- Main Function ---

// Simple struct to define edges for clarity
struct Edge {
    from: Vertex,
    to: Vertex,
}

fn main() {
    let edges = vec![
        Edge { from: 4, to: 2 }, Edge { from: 2, to: 3 }, Edge { from: 3, to: 2 },
        Edge { from: 6, to: 0 }, Edge { from: 0, to: 1 }, Edge { from: 2, to: 0 },
        Edge { from: 11, to: 12 }, Edge { from: 12, to: 9 }, Edge { from: 9, to: 10 },
        Edge { from: 9, to: 11 }, Edge { from: 8, to: 9 }, Edge { from: 10, to: 12 },
        Edge { from: 0, to: 5 }, Edge { from: 5, to: 4 }, Edge { from: 3, to: 5 },
        Edge { from: 6, to: 4 }, Edge { from: 6, to: 9 }, Edge { from: 7, to: 6 },
        Edge { from: 7, to: 8 }, Edge { from: 8, to: 7 }, Edge { from: 5, to: 3 },
        Edge { from: 0, to: 6 },
    ];

    let vertex_count = 13;
    let mut digraph = Digraph::new(vertex_count);

    for edge in &edges {
        digraph.add_edge(edge.from, edge.to);
    }

    println!("Constructed digraph:");
    println!("{}", digraph); // Uses the Display trait implementation

    let gabow_scc = GabowScc::new(&digraph);
    println!("It has {} strongly connected components.", gabow_scc.scc_count());

    let components = gabow_scc.get_components();
    println!("\nComponents:");
    for (i, component) in components.iter().enumerate() {
        print!("Component {}: ", i);
        for &vertex in component {
            print!("{} ", vertex);
        }
        println!();
    }

    // Example usage of the is_strongly_connected() and get_component_id() methods
    println!("\nExample connectivity checks:");
    println!("Vertices 0 and 3 strongly connected? {}", gabow_scc.is_strongly_connected(0, 3));
    println!("Vertices 0 and 7 strongly connected? {}", gabow_scc.is_strongly_connected(0, 7));
    println!("Vertices 9 and 12 strongly connected? {}", gabow_scc.is_strongly_connected(9, 12));
    // get_component_id returns Option<usize>, use {:?} for easy printing or match/if let
    println!("Component ID of vertex 5: {:?}", gabow_scc.get_component_id(5));
    println!("Component ID of vertex 8: {:?}", gabow_scc.get_component_id(8));

    // Example of handling the Option explicitly:
    match gabow_scc.get_component_id(5) {
        Some(id) => println!("Component ID of vertex 5 (explicit handling): {}", id),
        None => println!("Vertex 5 has no assigned component ID."),
    }
}
