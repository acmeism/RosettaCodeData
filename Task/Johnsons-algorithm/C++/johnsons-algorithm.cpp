#include <cstdint>
#include <iostream>
#include <limits>
#include <map>
#include <optional>
#include <queue>
#include <vector>

constexpr double INF{std::numeric_limits<double>::max()};

struct Edge {
	uint32_t u;
	uint32_t v;
	double weight;
};

struct Vertex_and_Weight {
	uint32_t vertex;
	double weight;
};

/**
 * Return a list of shortest path distances from the source vertex in the original graph to all other vertices
 */
std::vector<double> dijkstra_algorithm(
		const uint32_t& vertex_count,
		std::map<uint32_t, std::vector<Vertex_and_Weight>>& reweighted_adjacencies,
		const uint32_t& source_vertex,
		const std::vector<double>& values) {

	std::vector<double> distances(vertex_count, INF);
	distances[source_vertex] = 0.0;

	auto compare = [](const Vertex_and_Weight& a, const Vertex_and_Weight& b) { return a.weight > b.weight; };

	std::priority_queue<Vertex_and_Weight, std::vector<Vertex_and_Weight>, decltype(compare)> priority_queue;
	priority_queue.emplace(Vertex_and_Weight(source_vertex, 0.0));

	std::vector<double> final_distances(vertex_count, INF);

	while ( ! priority_queue.empty() ) {
		Vertex_and_Weight vertex_and_Weight = priority_queue.top();
		priority_queue.pop();
		const uint32_t vertex = vertex_and_Weight.vertex;
		if ( vertex_and_Weight.weight > distances[vertex] ) {
			continue;
		}

		// Store the final shortest path distance, translated back to the distance in the original graph
		// which prevents processing vertices disconnected from the source vertex
		if ( final_distances[vertex] == INF ) {
			 if ( distances[vertex] == INF ) { // This should not happen, but is included as a safety check
				 final_distances[vertex] = INF;
			 } else {
				 // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
				 final_distances[vertex] = distances[vertex] - values[source_vertex] + values[vertex];
			 }
		}

		// Relax the edges outgoing from vertex
		if ( reweighted_adjacencies.contains(vertex) ) {
			for ( Vertex_and_Weight pair : reweighted_adjacencies[vertex] ) {
				if ( distances[vertex] != INF
					&& distances[vertex] + pair.weight < distances[pair.vertex] ) {
					distances[pair.vertex] = distances[vertex] + pair.weight;
					priority_queue.emplace(Vertex_and_Weight(pair.vertex, distances[pair.vertex]));
				}
			}
		}
	}

	// Translate distance back to its original weight for any remaining reachable vertices
	// This handles cases where a vertex was reachable, but was not the minimum vertex
	// removed from the priority queue when its final distance was determined.
	for ( uint32_t i = 0; i < vertex_count; ++i ) {
		 if ( final_distances[i] == INF && distances[i] != INF ) {
			 final_distances[i] = distances[i] - values[source_vertex] + values[i];
		 }
	}

	return final_distances;
}

/**
 * Return a list of shortest distances from the source vertex to all other vertices,
 * or an empty optional if a negative cycle is detected
 */
std::optional<std::vector<double>> bellman_ford_algorithm(
		const uint32_t& augmented_vertex_count, const std::vector<Edge>& edges, const uint32_t& source_vertex) {
	std::vector<double> distances(augmented_vertex_count, INF);
	distances[source_vertex] = 0.0;

	// Relax the edges (augmentedVertexCount - 1) times
	bool updated = true;
	for ( uint32_t i = 0; i < augmented_vertex_count - 1 && updated; ++i ) {
		updated = false;
		for ( uint32_t j = 0; j < edges.size(); ++j ) {
			Edge edge = edges[j];
			if ( distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] ) {
				distances[edge.v] = distances[edge.u] + edge.weight;
				updated = true;
			}
		}
	}

	// Check for negative cycles in the graph
	for ( const Edge& edge : edges ) {
		if ( distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v] ) {
			return std::nullopt; // Indicates to the calling method that a negative cycle has been detected
		}
	}

	return distances;
}

/**
 * Return the shortest path between all pairs of vertices in an edge weighted directed graph
 * For a full description of the algorithm visit https://en.wikipedia.org/wiki/Johnson%27s_algorithm
 */
std::optional<std::vector<std::vector<double>>> johnsons_algorithm(const std::vector<std::vector<double>>& graph) {
	const uint32_t vertex_count = graph.size();
	std::vector<Edge> original_edges;

	// Step 0: Build a list of edges for the original graph
	for ( uint32_t i = 0; i < vertex_count; ++i ) {
		for ( uint32_t j = 0; j < vertex_count; ++j ) {
			const double weight = graph[i][j];
			if ( i == j ) {
				if ( weight != 0.0 ) {
					std::cout << "Warning: graph[i][i] for i = " << i << " is " << weight
							  << ", expected to be 0.0, resetting it to 0.0" << std::endl;
				}
			} else if ( weight != INF ) {
				original_edges.emplace_back(Edge(i, j, weight));
			}
		}
	}

	// Step 1: Form the augmented graph
	// Add a new vertex with index 'vertex_count' and having 0-weight edges to all the original vertices
	std::vector<Edge> augmented_edges = original_edges;
	for ( uint32_t i = 0; i < vertex_count; ++i ) {
		augmented_edges.emplace_back(Edge(vertex_count, i, 0.0));
	}

	// Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
	std::optional<std::vector<double>> h_values =
        bellman_ford_algorithm(vertex_count + 1, augmented_edges, vertex_count);

	if ( ! h_values ) {
		return std::nullopt; // A negative cycle was detected by the Bellman-Ford Algorithm
	}

	std::vector<double> values = h_values.value();
	values.pop_back(); // Remove the value for the augmented vertex

	// Step 3: Reweight the edges
	std::map<uint32_t, std::vector<Vertex_and_Weight>> reweighted_adjacencies;

	for ( const Edge& edge : original_edges ) {
		// Ensure the 'values' are valid before reweighting
		if ( values[edge.u] == INF || values[edge.v] == INF ) {
			// This can happen if the original graph was not strongly connected to the augmented vertex.
			// While not strictly an error for Johnson's Algorithm, because paths might still exist between
			// reachable nodes, it means the reweighting might involve INF.
			// Computation can proceed since Dijkstra's Algorithm can handle INF.
			std::cout << "Warning: invalid hValues detected by the Bellman-Ford Algorithm." << std::endl;
		}

		const double reweight = edge.weight + values[edge.u] - values[edge.v];
		reweighted_adjacencies[edge.u].emplace_back(Vertex_and_Weight(edge.v, reweight));
	}

	// Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
	std::vector<std::vector<double>> all_pairs_shortest_paths;
	for ( uint32_t u = 0; u < vertex_count; ++u ) {
		all_pairs_shortest_paths.emplace_back(dijkstra_algorithm(vertex_count, reweighted_adjacencies, u, values));
	}

	// Step 5: Return the result matrix
	return all_pairs_shortest_paths;
}

int main() {
	// The element (i, j) is the weight of the edge from vertex i to vertex j.
	// INF, for infinity, means that there is no edge from vertex i to vertex j.
	const std::vector<std::vector<double>> graph = {
		{ 0.0, -5.0, 2.0, 3.0 },
		{ INF,  0.0, 4.0, INF },
		{ INF,  INF, 0.0, 1.0 },
		{ INF,  INF, INF, 0.0 } };

	const std::optional<std::vector<std::vector<double>>> result = johnsons_algorithm(graph);

	if ( result ) {
		std::cout << "All pairs shortest paths:" << std::endl;
		std::cout << "The element (i, j) is the shortest path between vertex i and vertex j." << std::endl;
		for ( const std::vector<double>& row : result.value() ) {
			std::cout << "[";
			for ( const double& number : row ) {
				if ( number == INF ) {
					std::cout << "INF ";
				} else {
					std::cout << number << " ";
				}
			}
			std::cout << "]" << std::endl;
		}
	} else {
		std::cout << "A negative cycle was detected in the graph." << std::endl;
	}
}
