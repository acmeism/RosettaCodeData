#include <algorithm>
#include <cstdint>
#include <iostream>
#include <set>
#include <string>
#include <unordered_map>
#include <vector>

std::vector<std::vector<std::string>> cliques{};

struct Edge {
	std::string start;
	std::string end;
};

template <typename T>
void print_vector(const std::vector<T>& vec) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vec.size() - 1; ++i ) {
		std::cout << vec[i] << ", ";
	}
	std::cout << vec.back() << "]";
}

template <typename T>
void print_2D_vector(const std::vector<std::vector<T>>& vecs) {
	std::cout << "[";
	for ( uint32_t i = 0; i < vecs.size() - 1; ++i ) {
		print_vector(vecs[i]); std::cout << ", ";
	}
	print_vector(vecs.back()); std::cout << "]" << std::endl;
}

void bron_kerbosch(const std::set<std::string>& current_clique,
				   std::set<std::string> candidates,
			       std::set<std::string> processed_vertices,
				   std::unordered_map<std::string, std::set<std::string>> graph) {

	if ( candidates.empty() && processed_vertices.empty() ) {
		if ( current_clique.size() > 2 ) {
			std::vector<std::string> clique(current_clique.begin(), current_clique.end());
			cliques.emplace_back(clique);
		}
		return;
	}

	// Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
	std::set<std::string> union_set(candidates.begin(), candidates.end());
	union_set.insert(processed_vertices.begin(), processed_vertices.end());
	const std::string pivot = *std::max_element(union_set.begin(), union_set.end(),
	    [&graph](const std::string& s1, const std::string& s2) { return graph[s1].size() < graph[s2].size(); });

	// 'possibles' are vertices in 'candidates' that are not neighbours of the 'pivot'
	std::set<std::string> possibles{};
	std::set_difference(candidates.begin(), candidates.end(),
		graph[pivot].begin(), graph[pivot].end(), std::inserter(possibles, possibles.begin()));

	for ( const std::string& vertex : possibles) {

		// Create a new clique including 'vertex'
		std::set<std::string> new_cliques(current_clique.begin(), current_clique.end());
		new_cliques.insert(vertex);

		// 'newCandidates' are the members of 'candidates' that are neighbours of 'vertex'
		std::set<std::string> new_candidates{};
		std::set_intersection(candidates.begin(), candidates.end(), graph[vertex].begin(), graph[vertex].end(),
			std::inserter(new_candidates, new_candidates.begin()));

		// 'newProcessedVertices' are members of 'processedVertices' that are neighbours of 'vertex'
		std::set<std::string> new_processed_vertices{};
		std::set_intersection(processed_vertices.begin(), processed_vertices.end(),
			graph[vertex].begin(), graph[vertex].end(),
			std::inserter(new_processed_vertices, new_processed_vertices.begin()));

		// Recursive call with the updated sets
		bron_kerbosch(new_cliques, new_candidates, new_processed_vertices, graph);

		// Move 'vertex' from 'candidates' to 'processedVertices'
		candidates.erase(vertex);
		processed_vertices.insert(vertex);
	}
}

int main() {
	const std::vector<Edge> edges = { Edge("a", "b"), Edge("b", "a"), Edge("a", "c"), Edge("c", "a"),
									  Edge("b", "c"), Edge("c", "b"), Edge("d", "e"), Edge("e", "d"),
									  Edge("d", "f"), Edge("f", "d"), Edge("e", "f"), Edge("f", "e") };

	// Build the graph as an adjacency list
	std::unordered_map<std::string, std::set<std::string>> graph{};
	std::for_each(edges.begin(), edges.end(),
		[&graph](const Edge& edge) { graph[edge.start].insert(edge.end); } );

	// Initialize current clique, candidates and processed vertices
	std::set<std::string> current_clique{};
	std::set<std::string> candidates{};
	std::transform(graph.begin(), graph.end(), std::inserter(candidates, candidates.end()),
	    [](const auto& pair) { return pair.first; } );
	std::set<std::string> processed_vertices{};

	// Execute the Bron-Kerbosch algorithm to collect the cliques
	bron_kerbosch(current_clique, candidates, processed_vertices, graph);

	// Sort the cliques for consistent display
	std::sort(cliques.begin(), cliques.end(),
		[](const std::vector<std::string>& a, const std::vector<std::string>& b) {
			for ( uint32_t i = 0; i < std::min(a.size(), b.size()); ++i ) {
				if ( a[i] != b[i] ) {
					return a[i] < b[i];
				}
			}
			return a.size() < b.size(); });

	// Display the cliques
	print_2D_vector(cliques);
}
