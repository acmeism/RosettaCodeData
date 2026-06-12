#include <algorithm>
#include <cstdint>
#include <iostream>
#include <stack>
#include <stdexcept>
#include <string>
#include <vector>

/**
 * Representation of a directed graph, or digraph, using adjacency lists.
 * Vertices are identified by integers starting from zero.
 */
class Digraph {
public:
	 Digraph(const uint32_t& a_vertex_count) {
         if ( a_vertex_count < 0 ) {
        	 throw std::invalid_argument("Number of vertices must be non-negative");
         }

         vertex_count = a_vertex_count;
         edge_count = 0;
         adjacency_lists = { vertex_count, std::vector<uint32_t>() };
    }

	void add_edge(const uint32_t& from, const uint32_t& to) {
		 validate_vertex(from);
		 validate_vertex(to);
		 adjacency_lists[from].emplace_back(to);
		 edge_count++;
	}

	std::string to_string() {
		std::string result = "Digraph has " + std::to_string(vertex_count) + " vertices and "
			+ std::to_string(edge_count) + " edges" + "\n" + "Adjacency lists:" + "\n";
		for ( uint32_t vertex = 0; vertex < vertex_count; ++vertex ) {
			result += ( vertex < 10 ? " " : "" ) + std::to_string(vertex) + ": ";
			std::sort(adjacency_lists[vertex].begin(), adjacency_lists[vertex].end());
			for ( const uint32_t& adjacent : adjacency_lists[vertex] ) {
				result += std::to_string(adjacent) + " ";
			}
			result += "\n";
		}
		return result;
	}

	uint32_t get_vertex_count() const {
		return vertex_count;
	}

	uint32_t get_edge_count() const {
		return edge_count;
	}

	std::vector<uint32_t> get_adjacency_list(const uint32_t& vertex) const {
		validate_vertex(vertex);
		return adjacency_lists[vertex];
	}

private:
	 void validate_vertex(const uint32_t& vertex) const {
		if ( vertex < 0 || vertex >= vertex_count ) {
			throw std::invalid_argument(
				"Vertex must be between 0 " + std::to_string(vertex_count) + ": " + std::to_string(vertex));
		}
	}

	uint32_t vertex_count;
	uint32_t edge_count;
	std::vector<std::vector<uint32_t>> adjacency_lists;
};

/**
 * Determination of the strongly connected components (SCC's) of a directed graph using Gabow's algorithm.
 */
class Gabow_SCC {
public:
	Gabow_SCC(const Digraph& digraph) {
	    visited.assign(digraph.get_vertex_count(), false);
	    component_IDs.assign(digraph.get_vertex_count(), UNDEFINED);
	    preorders.assign(digraph.get_vertex_count(), UNDEFINED);
	    preorder_count = 0;
	    scc_count = 0;

	    for ( uint32_t vertex = 0; vertex < digraph.get_vertex_count(); ++vertex ) {
	    	if ( ! visited[vertex] ) {
	    		depth_first_search(digraph, vertex);
	    	}
	    }
	}

	// Return, for each vertex, a list of its strongly connected vertices
	std::vector<std::vector<uint32_t>> get_components() {
		std::vector<std::vector<uint32_t>> components = { scc_count, std::vector<uint32_t>() };
		for ( uint32_t vertex = 0; vertex < visited.size(); ++vertex ) {
			const uint32_t component_id =  get_component_ID(vertex);
			if ( component_id != UNDEFINED ) { // This would normally be true
				components[component_id].emplace_back(vertex);
			} else {
				// Could be caused by the digraph edges being changed by the user
				throw std::invalid_argument(
					"Warning: Vertex " + std::to_string(vertex) + " has no SCC ID assigned.");
			}
		}
		return components;
	}

	// Return whether or not vertices 'v' and 'w' are in the same strongly connected component.
	bool is_strongly_connected(const uint32_t& v, const uint32_t& w) const {
		validate_vertex(v);
		validate_vertex(w);
		// If either vertex was not visited, for example, due to it being in an unconnected graph component,
		// its component_ID will be 'UNDEFINED', and they cannot be strongly connected unless
		// the graph is empty or has isolated vertices which is handled by the return condition below.
		return component_IDs[v] != UNDEFINED && component_IDs[v] == component_IDs[w];
	}

	// Return the component ID of the strong component containing 'vertex'.
	uint32_t get_component_ID(const uint32_t& vertex) const {
		validate_vertex(vertex);
		return component_IDs[vertex];
	}

	uint32_t get_scc_count() const {
		return scc_count;
	}

private:
	void depth_first_search(const Digraph& digraph, const uint32_t& vertex) {
		visited[vertex] = true;
		preorders[vertex] = preorder_count;
		preorder_count++;
		visited_vertices_stack.push(vertex);
		auxiliary_stack.push(vertex);

		for ( const uint32_t& adjacent : digraph.get_adjacency_list(vertex) ) {
			if ( ! visited[adjacent] ) {
				depth_first_search(digraph, adjacent);
				// If 'adjacent' is visited, but not yet assigned to a SCC,
				// then 'adjacent' is on the current depth first path,
				// or in a SCC which has already been processed in this depth first path,
				// and this will be handled by the 'auxiliary_stack'.
			} else if ( component_IDs[adjacent] == UNDEFINED ) {
				// Pop vertices from the 'auxiliary_stack'
				// until the top vertex has a preorder <= preorder of 'adjacent'.
				// This maintains the invariant that 'auxiliary_stack' contains a path of potential SCC roots.
				while ( ! auxiliary_stack.empty() && preorders[auxiliary_stack.top()] > preorders[adjacent] ) {
					auxiliary_stack.pop();
				}
			}
		}

		// 'vertex' is the root of a SCC,
		// if it remains on top of the 'auxiliary_stack' after exploring all of its descendants and back-edges.
		if ( ! auxiliary_stack.empty() && auxiliary_stack.top() == vertex ) {
			auxiliary_stack.pop();
			// Pop vertices from the 'auxiliart_stack' until 'vertex' is popped,
			// and assign these vertices the current strongly connected component id.
			while ( ! visited_vertices_stack.empty() ) {
				const uint32_t adjacent = visited_vertices_stack.top();
				visited_vertices_stack.pop();
				component_IDs[adjacent] = scc_count;
				if ( adjacent == vertex ) {
					break;
				}
			}
			scc_count++;
		}
	}

	void validate_vertex(const uint32_t& vertex) const {
		const uint32_t visited_count = visited.size();
		if ( vertex < 0 || vertex >= visited_count ) {
			throw std::invalid_argument(
				"Vertex " + std::to_string(vertex) + " is not between 0 and " + std::to_string(visited_count - 1));
		}
	}

	std::vector<bool> visited; // stores the vertices that have been visited
	std::vector<uint32_t> component_IDs; // the unique id number of each strongly connected component
	std::vector<uint32_t> preorders; // stores the preorder of vertices
	uint32_t preorder_count; // the number of preorders of vertices
	uint32_t scc_count; // the number of strongly connected components
	std::stack<uint32_t> visited_vertices_stack; // stores vertices in the order of their visit
	std::stack<uint32_t> auxiliary_stack; // auxiliary stack for finding SCC roots

	const uint32_t UNDEFINED = -1;
};

int main() {
	struct Edge {
		uint32_t from;
		uint32_t to;
	};

	const std::vector<Edge> edges = { Edge{4, 2}, Edge{2, 3}, Edge{3, 2}, Edge{6, 0}, Edge{0, 1}, Edge{2, 0},
		Edge{11, 12}, Edge{12, 9}, Edge{9, 10}, Edge{9, 11}, Edge{8, 9}, Edge{10, 12}, Edge{0, 5}, Edge{5, 4},
		Edge{3, 5}, Edge{6, 4}, Edge{6, 9}, Edge{7, 6}, Edge{7, 8}, Edge{8, 7}, Edge{5, 3}, Edge{0, 6} };

	Digraph digraph(13);

	for ( const Edge& edge : edges ) {
		digraph.add_edge(edge.from, edge.to);
	}

	std::cout << "Constructed digraph:" << std::endl;
	std::cout << digraph.to_string() << std::endl;

	Gabow_SCC gabow_SCC(digraph);
	std::cout << "It has " << gabow_SCC.get_scc_count() << " strongly connected components." << std::endl;

	const std::vector<std::vector<uint32_t>> components = gabow_SCC.get_components();
	std::cout << "\n" << "Components:" << std::endl;
	for ( uint32_t i = 0; i < components.size(); ++i ) {
		std::cout << "Component " << i << ": ";
		for ( const uint32_t& vertex : components[i] ) {
			std::cout << vertex << " ";
		}
		std::cout << std::endl;
	}

	// Example usage of the is_strongly_connected() and get_component_ID() methods
	std::cout << "\n" << "Example connectivity checks:" << std::boolalpha << std::endl;
	std::cout << "Vertices 0 and 3 strongly connected? " << gabow_SCC.is_strongly_connected(0, 3) << std::endl;
	std::cout << "Vertices 0 and 7 strongly connected? " << gabow_SCC.is_strongly_connected(0, 7) << std::endl;
	std::cout << "Vertices 9 and 12 strongly connected? " << gabow_SCC.is_strongly_connected(9, 12) << std::endl;
	std::cout << "Component ID of vertex 5: " << gabow_SCC.get_component_ID(5) << std::endl;
	std::cout << "Component ID of vertex 8: " << gabow_SCC.get_component_ID(8) << std::endl;
}
