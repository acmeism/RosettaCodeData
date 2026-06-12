use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};
use std::f64::MAX as INF;

#[derive(Debug, Clone, Copy)]
struct Edge {
    u: usize,
    v: usize,
    weight: f64,
}

#[derive(Debug, Clone, Copy)]
struct VertexAndWeight {
    v: usize,
    weight: f64,
}

// Custom wrapper for f64 to implement Ord
#[derive(Debug, Clone, Copy)]
struct OrderedFloat(f64);

impl PartialEq for OrderedFloat {
    fn eq(&self, other: &Self) -> bool {
        self.0.eq(&other.0)
    }
}

// This is technically not sound for NaN values, but for our algorithm we won't have NaN
impl Eq for OrderedFloat {}

impl PartialOrd for OrderedFloat {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        self.0.partial_cmp(&other.0)
    }
}

impl Ord for OrderedFloat {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap_or(Ordering::Equal)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct WeightAndVertex {
    weight: OrderedFloat,
    vertex: usize,
}

impl PartialOrd for WeightAndVertex {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for WeightAndVertex {
    fn cmp(&self, other: &Self) -> Ordering {
        // Min heap (reverse ordering)
        other.weight.cmp(&self.weight)
    }
}

fn johnsons_algorithm(graph: &Vec<Vec<f64>>) -> Option<Vec<Vec<f64>>> {
    let vertex_count = graph.len();
    let mut original_edges = Vec::new();

    // Step 0: Build a list of edges for the original graph
    for i in 0..vertex_count {
        for j in 0..vertex_count {
            let weight = graph[i][j];
            if i == j {
                if weight != 0.0 {
                    println!("Warning: graph[i][i] for i = {} is {}, expected to be 0.0, resetting it to 0.0", i, weight);
                }
            } else if weight != INF {
                original_edges.push(Edge { u: i, v: j, weight });
            }
        }
    }

    // Step 1: Form the augmented graph
    // Add a new vertex with index 'vertex_count' and having 0-weight edges to all the original vertices
    let mut augmented_edges = original_edges.clone();
    for i in 0..vertex_count {
        augmented_edges.push(Edge { u: vertex_count, v: i, weight: 0.0 });
    }

    // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
    let h_values_opt = bellman_ford_algorithm(vertex_count + 1, &augmented_edges, vertex_count);

    if h_values_opt.is_none() {
        return None; // A negative cycle was detected by the Bellman-Ford Algorithm
    }

    let mut h_values = h_values_opt.unwrap();
    h_values.pop(); // Remove the value for the augmented vertex

    // Step 3: Reweight the edges
    let mut reweighted_adjacencies: HashMap<usize, Vec<VertexAndWeight>> =
        (0..vertex_count).map(|v| (v, Vec::new())).collect();

    for edge in &original_edges {
        // Ensure the 'values' are valid before reweighting
        if h_values[edge.u] == INF || h_values[edge.v] == INF {
            // This can happen if the original graph was not strongly connected to the augmented vertex.
            // While not strictly an error for Johnson's Algorithm, because paths might still exist between
            // reachable nodes, it means the reweighting might involve INF.
            // Computation can proceed since Dijkstra's Algorithm can handle INF.
            println!("Warning: invalid hValues detected by the Bellman-Ford Algorithm.");
        }

        let reweight = edge.weight + h_values[edge.u] - h_values[edge.v];
        reweighted_adjacencies.get_mut(&edge.u).unwrap().push(VertexAndWeight { v: edge.v, weight: reweight });
    }

    // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
    let all_pairs_shortest_paths: Vec<Vec<f64>> = (0..vertex_count)
        .map(|u| dijkstra_algorithm(vertex_count, &reweighted_adjacencies, u, &h_values))
        .collect();

    // Step 5: Return the result matrix
    Some(all_pairs_shortest_paths)
}

fn bellman_ford_algorithm(
    augmented_vertex_count: usize,
    edges: &Vec<Edge>,
    source_vertex: usize,
) -> Option<Vec<f64>> {
    let mut distances = vec![INF; augmented_vertex_count];
    distances[source_vertex] = 0.0;

    // Relax the edges (augmented_vertex_count - 1) times
    let mut updated = true;
    for _ in 0..(augmented_vertex_count - 1) {
        if !updated {
            break;
        }
        updated = false;
        for edge in edges {
            if distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] {
                distances[edge.v] = distances[edge.u] + edge.weight;
                updated = true;
            }
        }
    }

    // Check for negative cycles in the graph
    for edge in edges {
        if distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] {
            return None; // Indicates to the calling method that a negative cycle has been detected
        }
    }

    Some(distances)
}

fn dijkstra_algorithm(
    vertex_count: usize,
    reweighted_adjacencies: &HashMap<usize, Vec<VertexAndWeight>>,
    source_vertex: usize,
    values: &Vec<f64>,
) -> Vec<f64> {
    let mut distances = vec![INF; vertex_count];
    distances[source_vertex] = 0.0;

    let mut priority_queue = BinaryHeap::new();
    priority_queue.push(WeightAndVertex {
        weight: OrderedFloat(0.0),
        vertex: source_vertex,
    });

    let mut final_distances = vec![INF; vertex_count];

    while let Some(weight_and_vertex) = priority_queue.pop() {
        let vertex = weight_and_vertex.vertex;
        if weight_and_vertex.weight.0 > distances[vertex] {
            continue;
        }

        // Store the final shortest path distance, translated back to the distance in the original graph
        // which prevents processing vertices disconnected from the source vertex
        if final_distances[vertex] == INF {
            if distances[vertex] == INF {
                // This should not happen, but is included as a safety check
                final_distances[vertex] = INF;
            } else {
                // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
                final_distances[vertex] = distances[vertex] - values[source_vertex] + values[vertex];
            }
        }

        // Relax the edges outgoing from vertex
        if let Some(adjacencies) = reweighted_adjacencies.get(&vertex) {
            for pair in adjacencies {
                if distances[vertex] != INF && distances[vertex] + pair.weight < distances[pair.v] {
                    distances[pair.v] = distances[vertex] + pair.weight;
                    priority_queue.push(WeightAndVertex {
                        weight: OrderedFloat(distances[pair.v]),
                        vertex: pair.v,
                    });
                }
            }
        }
    }

    // Translate distance back to its original weight for any remaining reachable vertices
    // This handles cases where a vertex was reachable, but was not the minimum vertex
    // removed from the priority queue when its final distance was determined.
    for i in 0..vertex_count {
        if final_distances[i] == INF && distances[i] != INF {
            final_distances[i] = distances[i] - values[source_vertex] + values[i];
        }
    }

    final_distances
}

fn main() {
    // The element (i, j) is the weight of the edge from vertex i to vertex j.
    // INF, for infinity, means that there is no edge from vertex i to vertex j.
    let graph = vec![
        vec![0.0, -5.0, 2.0, 3.0],
        vec![INF, 0.0, 4.0, INF],
        vec![INF, INF, 0.0, 1.0],
        vec![INF, INF, INF, 0.0],
    ];

    match johnsons_algorithm(&graph) {
        Some(result) => {
            println!("All pairs shortest paths:");
            println!("The element (i, j) is the shortest path between vertex i and vertex j.");
            for row in result {
                print!("[");
                for number in row {
                    if number == INF {
                        print!("INF ");
                    } else {
                        print!("{} ", number);
                    }
                }
                println!("]");
            }
        }
        None => {
            println!("A negative cycle was detected in the graph.");
        }
    }
}
