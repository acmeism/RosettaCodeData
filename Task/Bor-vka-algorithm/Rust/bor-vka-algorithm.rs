// Structure to represent a graph
struct Graph {
    v: usize,      // Number of vertices
    graph: Vec<Vec<i32>>, // List of edges [u, v, w]
}

impl Graph {
    fn new(vertices: usize) -> Self {
        Graph {
            v: vertices,
            graph: Vec::new(),
        }
    }

    // Function to add an edge to the graph
    fn add_edge(&mut self, u: i32, v: i32, w: i32) {
        self.graph.push(vec![u, v, w]);
    }

    // A utility function to find the set of an element i
    // (uses path compression technique)
    fn find(&self, parent: &mut Vec<usize>, i: usize) -> usize {
        if parent[i] == i {
            return i;
        }
        let result = self.find(parent, parent[i]);
        parent[i] = result; // Path compression
        result
    }

    // A function that performs union of two sets x and y
    // (uses union by rank)
    fn union_set(&self, parent: &mut Vec<usize>, rank: &mut Vec<usize>, x: usize, y: usize) {
        let x_root = self.find(parent, x);
        let y_root = self.find(parent, y);

        // Attach smaller rank tree under root of high rank tree
        if rank[x_root] < rank[y_root] {
            parent[x_root] = y_root;
        } else if rank[x_root] > rank[y_root] {
            parent[y_root] = x_root;
        } else {
            // If ranks are the same, make one as root and increment its rank
            parent[y_root] = x_root;
            rank[x_root] += 1;
        }
    }

    // The main function to construct MST using Boruvka's algorithm
    fn boruvka_mst(&self) {
        let mut parent: Vec<usize> = (0..self.v).collect();
        let mut rank: Vec<usize> = vec![0; self.v];

        // An array to store the index of the cheapest edge of each subset
        // It stores [u, v, w] for each component
        let mut cheapest: Vec<Vec<i32>> = vec![vec![-1, -1, -1]; self.v];

        // Initially there are V different trees
        // Finally there will be one tree that will be the MST
        let mut num_trees = self.v;
        let mut mst_weight = 0;

        // Keep combining components (or sets) until all
        // components are combined into a single MST
        while num_trees > 1 {
            // Traverse through all edges and update
            // cheapest edge for every component
            for edge in &self.graph {
                let u = edge[0] as usize;
                let v = edge[1] as usize;
                let w = edge[2];

                let set1 = self.find(&mut parent, u);
                let set2 = self.find(&mut parent, v);

                // If two corners of current edge belong to different sets,
                // check if current edge is cheaper than previous cheapest edges
                if set1 != set2 {
                    if cheapest[set1][2] == -1 || cheapest[set1][2] > w {
                        cheapest[set1] = vec![u as i32, v as i32, w];
                    }
                    if cheapest[set2][2] == -1 || cheapest[set2][2] > w {
                        cheapest[set2] = vec![u as i32, v as i32, w];
                    }
                }
            }

            // Consider the picked cheapest edges and add them to the MST
            for node in 0..self.v {
                // Check if cheapest edge for current set exists
                if cheapest[node][2] != -1 {
                    let u = cheapest[node][0] as usize;
                    let v = cheapest[node][1] as usize;
                    let w = cheapest[node][2];

                    let set1 = self.find(&mut parent, u);
                    let set2 = self.find(&mut parent, v);

                    if set1 != set2 {
                        mst_weight += w;
                        self.union_set(&mut parent, &mut rank, set1, set2);
                        println!("Edge {}-{} with weight {} included in MST", u, v, w);
                        num_trees -= 1;
                    }
                }
            }

            // Reset cheapest array for next iteration
            for node in 0..self.v {
                cheapest[node][2] = -1;
            }
        }

        println!("Weight of MST is {}", mst_weight);
    }
}

fn main() {
    let mut g = Graph::new(4);
    g.add_edge(0, 1, 10);
    g.add_edge(0, 2, 6);
    g.add_edge(0, 3, 5);
    g.add_edge(1, 3, 15);
    g.add_edge(2, 3, 4);

    g.boruvka_mst();
}
