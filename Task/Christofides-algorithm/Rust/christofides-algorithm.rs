use std::collections::HashSet;
use std::f64;
use rand::seq::SliceRandom;
use rand::thread_rng;

// --- Structs ---

#[derive(Debug, Clone, Copy, PartialEq)]
struct Point {
    id: usize, // Original index or assigned ID
    x: f64,
    y: f64,
}

#[derive(Debug, Clone, Copy)]
struct Edge {
    u: usize,
    v: usize,
    weight: f64,
}

// Implement PartialEq, Eq, PartialOrd, Ord for sorting Edges by weight
impl PartialEq for Edge {
    fn eq(&self, other: &Self) -> bool {
        self.weight == other.weight
    }
}
impl Eq for Edge {}

impl PartialOrd for Edge {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        self.weight.partial_cmp(&other.weight)
    }
}

impl Ord for Edge {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.partial_cmp(other).unwrap_or(std::cmp::Ordering::Equal) // Panic on NaN, ok for this problem
    }
}


// --- Helper Functions ---

fn print_usize_vec(vec: &[usize], name: &str) {
    let content: Vec<String> = vec.iter().map(|&x| x.to_string()).collect();
    println!("{}: [{}]", name, content.join(", "));
}

fn print_edges(edges: &[Edge], name: &str) {
    let edge_strings: Vec<String> = edges
        .iter()
        .map(|e| format!("({}, {}, {:.2})", e.u, e.v, e.weight))
        .collect();
    println!("{}: [{}]", name, edge_strings.join(", "));
}

fn print_graph(graph: &[Vec<f64>], name: &str) {
    println!("{}: {{", name);
    let n = graph.len();
    for i in 0..n {
        let entries: Vec<String> = (0..n)
            .filter(|&j| i != j)
            .map(|j| format!("{}: {:.2}", j, graph[i][j]))
            .collect();
        println!("  {}: {{{}}}{}", i, entries.join(", "), if i == n - 1 { "" } else { "," });
    }
    println!("}}");
}


// --- Euclidean Distance ---
fn get_length(p1: Point, p2: Point) -> f64 {
    let dx = p1.x - p2.x;
    let dy = p1.y - p2.y;
    (dx * dx + dy * dy).sqrt()
}

// --- Build Complete Graph (Adjacency Matrix) ---
fn build_graph(data: &[Point]) -> Vec<Vec<f64>> {
    let n = data.len();
    let mut graph = vec![vec![0.0; n]; n];
    for i in 0..n {
        for j in i + 1..n { // Only calculate upper triangle
            let dist = get_length(data[i], data[j]);
            graph[i][j] = dist;
            graph[j][i] = dist; // Symmetric graph
        }
    }
    graph
}

// --- Union-Find Data Structure ---
struct UnionFind {
    parent: Vec<usize>,
    rank: Vec<usize>,
}

impl UnionFind {
    fn new(n: usize) -> Self {
        UnionFind {
            parent: (0..n).collect(),
            rank: vec![0; n],
        }
    }

    fn find(&mut self, i: usize) -> usize {
        if self.parent[i] == i {
            i
        } else {
            // Path compression
            self.parent[i] = self.find(self.parent[i]);
            self.parent[i]
        }
    }

    fn unite(&mut self, i: usize, j: usize) -> bool {
        let root_i = self.find(i);
        let root_j = self.find(j);
        if root_i != root_j {
            // Union by rank
            if self.rank[root_i] < self.rank[root_j] {
                self.parent[root_i] = root_j;
            } else if self.rank[root_i] > self.rank[root_j] {
                self.parent[root_j] = root_i;
            } else {
                self.parent[root_j] = root_i;
                self.rank[root_i] += 1;
            }
            true
        } else {
            false
        }
    }
}

// --- Minimum Spanning Tree (Kruskal's Algorithm) ---
fn minimum_spanning_tree(graph: &[Vec<f64>]) -> Vec<Edge> {
    let n = graph.len();
    if n == 0 {
        return vec![];
    }

    let mut edges = Vec::new();
    for i in 0..n {
        for j in i + 1..n { // Avoid duplicates and self-loops
            edges.push(Edge { u: i, v: j, weight: graph[i][j] });
        }
    }

    // Sort edges by weight
    edges.sort_unstable(); // Uses the Ord implementation

    let mut mst = Vec::new();
    let mut uf = UnionFind::new(n);
    let mut edges_count = 0;

    for &edge in &edges {
        if uf.unite(edge.u, edge.v) {
            mst.push(edge);
            edges_count += 1;
            if edges_count == n - 1 { // Optimization: MST has n-1 edges
                break;
            }
        }
    }
    mst
}

// --- Find Vertices with Odd Degree in MST ---
fn find_odd_vertexes(mst: &[Edge], n: usize) -> Vec<usize> {
    let mut degree = vec![0; n];
    for edge in mst {
        degree[edge.u] += 1;
        degree[edge.v] += 1;
    }

    (0..n).filter(|&i| degree[i] % 2 != 0).collect()
}

// --- Minimum Weight Matching (Greedy Heuristic) ---
// Note: This modifies the multigraph_edges vector by adding matching edges.
fn minimum_weight_matching(
    multigraph_edges: &mut Vec<Edge>,
    graph: &[Vec<f64>],
    odd_vertices: &[usize],
) {
    let n = graph.len();
    if odd_vertices.is_empty() {
        return;
    }

    let mut current_odd = odd_vertices.to_vec(); // Clone to allow shuffling and tracking
    let mut rng = thread_rng();
    current_odd.shuffle(&mut rng); // Shuffle for randomness

    let mut matched = vec![false; n]; // Keep track of vertices matched in this phase

    // We use a marker for visited indices in the shuffled list
    let mut processed = vec![false; current_odd.len()];

    for i in 0..current_odd.len() {
        if processed[i] { continue; } // Skip if already processed (matched)

        let v = current_odd[i];
        let mut min_length = f64::INFINITY;
        let mut closest_u_idx: Option<usize> = None; // Store index in current_odd

        // Find the closest *unmatched* odd vertex *later* in the shuffled list
        for j in i + 1..current_odd.len() {
            if !processed[j] { // Check if 'u' (at current_odd[j]) is available
                 let u = current_odd[j];
                 if graph[v][u] < min_length {
                     min_length = graph[v][u];
                     closest_u_idx = Some(j);
                 }
            }
        }

        if let Some(j) = closest_u_idx {
            let u = current_odd[j];
            // Add the matching edge to the MST list (now a multigraph)
            multigraph_edges.push(Edge { u: v, v: u, weight: min_length });

            // Mark both as processed in the shuffled list context
            processed[i] = true;
            processed[j] = true;
            // Optionally mark in the global 'matched' array if needed elsewhere
             matched[v] = true;
             matched[u] = true;

        } else {
             // This *shouldn't* happen in Christofides as the number of odd vertices is always even.
             // If it does, it might indicate an issue earlier or a graph where matching isn't possible?
             eprintln!("Warning: Could not find match for odd vertex {} in greedy matching.", v);
        }
    }
}


// --- Find Eulerian Tour (Hierholzer's Algorithm) ---
fn find_eulerian_tour(multigraph_edges: &[Edge], n: usize) -> Vec<usize> {
    if multigraph_edges.is_empty() {
        return vec![];
    }

    // Build adjacency list: adj[u] = Vec<(neighbor, edge_index)>
    let mut adj: Vec<Vec<(usize, usize)>> = vec![vec![]; n];
    for (edge_idx, edge) in multigraph_edges.iter().enumerate() {
        adj[edge.u].push((edge.v, edge_idx));
        adj[edge.v].push((edge.u, edge_idx));
    }

    let mut edge_used = vec![false; multigraph_edges.len()];
    let mut tour = Vec::new();
    let mut stack = Vec::new();

    // Start at any vertex with edges
    let start_node = multigraph_edges[0].u;
    stack.push(start_node);

    while let Some(&current_node) = stack.last() {
        let mut found_edge = false;
        // Try to find an unused edge using pop for efficiency
        while let Some((neighbor, edge_idx)) = adj[current_node].pop() {
            if !edge_used[edge_idx] {
                edge_used[edge_idx] = true;
                stack.push(neighbor);
                found_edge = true;
                break; // Move to the neighbor
            }
            // If edge was used, loop continues popping from adj[current_node]
        }

        // If no unused edge was found from current_node (adj list is empty or all remaining edges used)
        if !found_edge {
            tour.push(stack.pop().unwrap()); // Backtrack
        }
    }

    // The tour is constructed in reverse order
    tour.reverse();
    tour
}


// --- Main TSP Function (Christofides Approximation) ---
fn tsp(data: &[Point]) -> (f64, Vec<usize>) {
    let n = data.len();
    if n == 0 {
        return (0.0, vec![]);
    }
    if n == 1 {
        return (0.0, vec![data[0].id]); // Use the point's ID
    }

    println!("Building graph...");
    let graph = build_graph(data);
    // print_graph(&graph, "Graph"); // Can be very large

    println!("Finding Minimum Spanning Tree...");
    let mst = minimum_spanning_tree(&graph);
    print_edges(&mst, "MSTree");

    println!("Finding odd degree vertices...");
    let odd_vertices = find_odd_vertexes(&mst, n);
    print_usize_vec(&odd_vertices, "Odd vertexes in MSTree");

    println!("Finding Minimum Weight Matching (greedy)...");
    // Clone MST edges to create the initial multigraph
    let mut multigraph_edges = mst.clone();
    // Add matching edges to the multigraph_edges vector
    minimum_weight_matching(&mut multigraph_edges, &graph, &odd_vertices);
    print_edges(&multigraph_edges, "Minimum weight matching (MST + Matching Edges)");

    println!("Finding Eulerian Tour...");
    let eulerian_tour = find_eulerian_tour(&multigraph_edges, n);
    print_usize_vec(&eulerian_tour, "Eulerian tour");

    // --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    println!("Creating Hamiltonian path (shortcutting)...");
    if eulerian_tour.is_empty() && n > 0 {
         eprintln!("Error: Eulerian tour could not be found.");
         return (-1.0, vec![]); // Indicate error
    }

    let mut path = Vec::new();
    let mut length = 0.0;
    let mut visited = HashSet::new(); // Use HashSet for O(1) average lookup

    let mut last_node_in_path: Option<usize> = None;

    for &node in &eulerian_tour {
        // visited.insert returns true if the value was not already present
        if visited.insert(node) {
            if let Some(last_node) = last_node_in_path {
                // Add distance from the *previous node added to the path*
                length += graph[last_node][node];
            }
            path.push(node); // Add node to the Hamiltonian path
            last_node_in_path = Some(node); // Update the last node *in the path*
        }
    }

    // Add the edge back to the start to complete the cycle
    if let (Some(last), Some(&first)) = (last_node_in_path, path.first()) {
         length += graph[last][first];
         path.push(first); // Add the starting node ID again to show the cycle
    }


    print_usize_vec(&path, "Result path");
    println!("Result length of the path: {:.2}", length);

    (length, path)
}


// --- Main Function ---
fn main() {
    // Input data matching the Python/JS example
     let raw_data: Vec<(f64, f64)> = vec![
        (1380.0, 939.0), (2848.0, 96.0), (3510.0, 1671.0), (457.0, 334.0), (3888.0, 666.0),
        (984.0, 965.0), (2721.0, 1482.0), (1286.0, 525.0), (2716.0, 1432.0), (738.0, 1325.0),
        (1251.0, 1832.0), (2728.0, 1698.0), (3815.0, 169.0), (3683.0, 1533.0), (1247.0, 1945.0),
        (123.0, 862.0), (1234.0, 1946.0), (252.0, 1240.0), (611.0, 673.0), (2576.0, 1676.0),
        (928.0, 1700.0), (53.0, 857.0), (1807.0, 1711.0), (274.0, 1420.0), (2574.0, 946.0),
        (178.0, 24.0), (2678.0, 1825.0), (1795.0, 962.0), (3384.0, 1498.0), (3520.0, 1079.0),
        (1256.0, 61.0), (1424.0, 1728.0), (3913.0, 192.0), (3085.0, 1528.0), (2573.0, 1969.0),
        (463.0, 1670.0), (3875.0, 598.0), (298.0, 1513.0), (3479.0, 821.0), (2542.0, 236.0),
        (3955.0, 1743.0), (1323.0, 280.0), (3447.0, 1830.0), (2936.0, 337.0), (1621.0, 1830.0),
        (3373.0, 1646.0), (1393.0, 1368.0), (3874.0, 1318.0), (938.0, 955.0), (3022.0, 474.0),
        (2482.0, 1183.0), (3854.0, 923.0), (376.0, 825.0), (2519.0, 135.0), (2945.0, 1622.0),
        (953.0, 268.0), (2628.0, 1479.0), (2097.0, 981.0), (890.0, 1846.0), (2139.0, 1806.0),
        (2421.0, 1007.0), (2290.0, 1810.0), (1115.0, 1052.0), (2588.0, 302.0), (327.0, 265.0),
        (241.0, 341.0), (1917.0, 687.0), (2991.0, 792.0), (2573.0, 599.0), (19.0, 674.0),
        (3911.0, 1673.0), (872.0, 1559.0), (2863.0, 558.0), (929.0, 1766.0), (839.0, 620.0),
        (3893.0, 102.0), (2178.0, 1619.0), (3822.0, 899.0), (378.0, 1048.0), (1178.0, 100.0),
        (2599.0, 901.0), (3416.0, 143.0), (2961.0, 1605.0), (611.0, 1384.0), (3113.0, 885.0),
        (2597.0, 1830.0), (2586.0, 1286.0), (161.0, 906.0), (1429.0, 134.0), (742.0, 1025.0),
        (1625.0, 1651.0), (1187.0, 706.0), (1787.0, 1009.0), (22.0, 987.0), (3640.0, 43.0),
        (3756.0, 882.0), (776.0, 392.0), (1724.0, 1642.0), (198.0, 1810.0), (3950.0, 1558.0),
    ];

    // Convert raw data to Point structs, using index as ID
    let data_points: Vec<Point> = raw_data
        .into_iter()
        .enumerate() // Get index along with coordinates
        .map(|(i, (x, y))| Point { id: i, x, y })
        .collect();

    // --- Run TSP ---
    let (_length, _path) = tsp(&data_points);
     // Result is already printed within tsp function
}
