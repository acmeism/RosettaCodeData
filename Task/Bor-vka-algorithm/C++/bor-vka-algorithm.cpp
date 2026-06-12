#include <cstdint>
#include <iostream>
#include <numeric>
#include <vector>

struct Edge {
	uint32_t u;
	uint32_t v;
	double weight;
};

class Graph {
public:
	Graph(const uint32_t& a_vertex_count) {
		vertex_count = a_vertex_count;
	}

    void add_edge(const Edge& edge) {
        edges.emplace_back(edge);
    }

    // Return the minimum spanning tree by using Boruvka's algorithm
	void borůvka_minimum_spanning_tree() {
		std::vector<uint32_t> parent(vertex_count);
		std::iota(parent.begin(), parent.end(), 0);
		std::vector<uint32_t> rank(vertex_count, 0);

		// Store the indexes of the cheapest edge for each tree
		std::vector<Edge> cheapest(vertex_count, Edge(-1, -1, -1.0));

		 // Initially there are 'vertex_count' different trees
		uint32_t tree_count = vertex_count;
		uint32_t minimum_spanning_tree_weight = 0;

		// Combine trees until all trees are combined into a single minimum spanning tree
		while ( tree_count > 1 ) {
			// Traverse through all edges and update cheapest edge for every tree
			for ( const Edge& edge : edges ) {
				const uint32_t u = edge.u;
				const uint32_t v = edge.v;
				const double weight = edge.weight;

				const uint32_t index1 = find(parent, u);
				const uint32_t index2 = find(parent, v);

				// If the two vertices of the current edge belong to different trees,
				// check whether the current edge is cheaper than previous cheapest edges
				if ( index1 != index2 ) {
					 if ( cheapest[index1].weight == -1.0 || cheapest[index1].weight > weight ) {
						 cheapest[index1] = Edge(u, v, weight);
					 }
					 if ( cheapest[index2].weight == -1.0 || cheapest[index2].weight > weight ) {
						 cheapest[index2] = Edge(u, v, weight);
					 }
				}
			}

			// Add the cheapest edges to the minimum spanning tree
			for ( uint32_t vertex = 0; vertex < vertex_count; ++vertex ) {
				// Check whether the cheapest edge for current vertex exists
				if ( cheapest[vertex].weight != -1.0 ) {
					const uint32_t u = cheapest[vertex].u;
					const uint32_t v = cheapest[vertex].v;
					const double weight = cheapest[vertex].weight;

					const uint32_t index1 = find(parent, u);
					const uint32_t index2 = find(parent, v);

					if ( index1 != index2 ) {
						minimum_spanning_tree_weight += weight;
						unionSet(parent, rank, index1, index2);
						std::cout << "Edge " << u << "--" << v << " with weight " << weight
								  << " is included in the minimum spanning tree" << std::endl;
						tree_count -= 1;
					}
				}
			}
		}

		std::cout << "\n" << "Weight of minimum spanning tree is " << minimum_spanning_tree_weight << std::endl;
	}

private:
    // Return the index of the tree containing 'vertex', using a path compression technique
    uint32_t find(std::vector<uint32_t>& parent, const uint32_t& vertex) {
		if ( parent[vertex] != vertex ) {
			parent[vertex] = find(parent, parent[vertex]);
		}

		return parent[vertex];
	}

    // Form the union by rank of the two trees indexed by u and v
	void unionSet(std::vector<uint32_t>& parent, std::vector<uint32_t>& rank, const uint32_t& u, const uint32_t& v) {
		const uint32_t uRoot = find(parent, u);
		const uint32_t vRoot = find(parent, v);

		// Attach the smaller rank tree under root of the high rank tree
		switch ( ( rank[uRoot] < rank[vRoot] ) ? -1 : ( rank[uRoot] > rank[vRoot] ) ) {
			case -1 : parent[uRoot] = vRoot; break;
			case +1 : parent[vRoot] = uRoot; break;
			// If ranks are the same, make one the root and increment its rank
			case  0 : { parent[vRoot] = uRoot; rank[uRoot] += 1; break; }
		}
	}

    std::vector<Edge> edges;
    uint32_t vertex_count;
};

int main() {
	Graph graph(4);
	graph.add_edge(Edge(0, 1, 10.0));
	graph.add_edge(Edge(0, 2,  6.0));
	graph.add_edge(Edge(0, 3,  5.0));
	graph.add_edge(Edge(1, 3, 15.0));
	graph.add_edge(Edge(2, 3,  4.0));

	graph.borůvka_minimum_spanning_tree();
}
