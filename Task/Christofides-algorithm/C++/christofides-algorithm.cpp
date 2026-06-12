#include <iostream>
#include <vector>
#include <cmath>
#include <numeric>
#include <algorithm>
#include <map>
#include <list>
#include <stack>
#include <limits>
#include <random>
#include <utility> // For std::pair
#include <iomanip> // For std::fixed and std::setprecision

// --- Helper Structs ---

struct Point {
    double x, y;
    int id; // Original index
};

struct Edge {
    int u, v;
    double weight;

    // For sorting edges by weight
    bool operator<(const Edge& other) const {
        return weight < other.weight;
    }
};

// --- Helper Function to print vectors/lists ---
template <typename T>
void print_container(const T& container, const std::string& name) {
    std::cout << name << ": [";
    bool first = true;
    for (const auto& item : container) {
        if (!first) {
            std::cout << ", ";
        }
        std::cout << item;
        first = false;
    }
    std::cout << "]" << std::endl;
}

void print_edges(const std::vector<Edge>& edges, const std::string& name) {
     std::cout << name << ": [";
    bool first = true;
    for (const auto& edge : edges) {
        if (!first) {
            std::cout << ", ";
        }
        std::cout << "(" << edge.u << ", " << edge.v << ", " << std::fixed << std::setprecision(2) << edge.weight << ")";
        first = false;
    }
    std::cout << "]" << std::endl;
}

void print_graph(const std::vector<std::vector<double>>& graph, const std::string& name) {
    std::cout << name << ": {" << std::endl;
    int n = graph.size();
    for (int i = 0; i < n; ++i) {
        std::cout << "  " << i << ": {";
        bool first = true;
        for (int j = 0; j < n; ++j) {
            if (i != j) {
                 if (!first) {
                    std::cout << ", ";
                }
                std::cout << j << ": " << std::fixed << std::setprecision(2) << graph[i][j];
                first = false;
            }
        }
         std::cout << "}" << (i == n-1 ? "" : ",") << std::endl;
    }
     std::cout << "}" << std::endl;
}


// --- Euclidean Distance ---
double get_length(const Point& p1, const Point& p2) {
    double dx = p1.x - p2.x;
    double dy = p1.y - p2.y;
    return std::sqrt(dx * dx + dy * dy);
}

// --- Build Complete Graph (Adjacency Matrix) ---
std::vector<std::vector<double>> build_graph(const std::vector<Point>& data) {
    int n = data.size();
    std::vector<std::vector<double>> graph(n, std::vector<double>(n, 0.0));
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) { // Only calculate upper triangle + diagonal is 0
            double dist = get_length(data[i], data[j]);
            graph[i][j] = dist;
            graph[j][i] = dist; // Symmetric graph
        }
    }
    return graph;
}

// --- Union-Find Data Structure ---
class UnionFind {
    std::vector<int> parent;
    std::vector<int> rank; // Or size

public:
    UnionFind(int n) {
        parent.resize(n);
        std::iota(parent.begin(), parent.end(), 0); // Fill with 0, 1, 2, ...
        rank.assign(n, 0);
    }

    int find(int i) {
        if (parent[i] == i)
            return i;
        // Path compression
        return parent[i] = find(parent[i]);
    }

    void unite(int i, int j) {
        int root_i = find(i);
        int root_j = find(j);
        if (root_i != root_j) {
            // Union by rank
            if (rank[root_i] < rank[root_j]) {
                parent[root_i] = root_j;
            } else if (rank[root_i] > rank[root_j]) {
                parent[root_j] = root_i;
            } else {
                parent[root_j] = root_i;
                rank[root_i]++;
            }
        }
    }
};

// --- Minimum Spanning Tree (Kruskal's Algorithm) ---
std::vector<Edge> minimum_spanning_tree(const std::vector<std::vector<double>>& graph) {
    int n = graph.size();
    if (n == 0) return {};

    std::vector<Edge> edges;
    for (int i = 0; i < n; ++i) {
        for (int j = i + 1; j < n; ++j) { // Avoid duplicates and self-loops
            edges.push_back({i, j, graph[i][j]});
        }
    }

    // Sort edges by weight
    std::sort(edges.begin(), edges.end());

    std::vector<Edge> mst;
    UnionFind uf(n);
    int edges_count = 0;

    for (const auto& edge : edges) {
        if (uf.find(edge.u) != uf.find(edge.v)) {
            mst.push_back(edge);
            uf.unite(edge.u, edge.v);
            edges_count++;
            if (edges_count == n - 1) { // Optimization: MST has n-1 edges
                break;
            }
        }
    }
    return mst;
}

// --- Find Vertices with Odd Degree in MST ---
std::vector<int> find_odd_vertexes(const std::vector<Edge>& mst, int n) {
    std::vector<int> degree(n, 0);
    for (const auto& edge : mst) {
        degree[edge.u]++;
        degree[edge.v]++;
    }

    std::vector<int> odd_vertices;
    for (int i = 0; i < n; ++i) {
        if (degree[i] % 2 != 0) {
            odd_vertices.push_back(i);
        }
    }
    return odd_vertices;
}

// --- Minimum Weight Matching (Greedy Heuristic) ---
// Note: This is a simplified greedy approach, not a true min-weight perfect matching.
// It modifies the mst vector by adding matching edges.
void minimum_weight_matching(std::vector<Edge>& mst, const std::vector<std::vector<double>>& graph, std::vector<int>& odd_vertices) {
    // Use a copy to allow modification while iterating
    std::vector<int> current_odd = odd_vertices;

    // Shuffle for randomness (like the Python version)
    // This makes the output non-deterministic unless seeded
    std::random_device rd;
    std::mt19937 g(rd()); // Mersenne Twister random number generator
    std::shuffle(current_odd.begin(), current_odd.end(), g);

    // Keep track of vertices already matched in this phase
    std::vector<bool> matched(graph.size(), false);

    for (int i = 0; i < current_odd.size(); ++i) {
        int v = current_odd[i];
        if (matched[v]) continue; // Skip if already matched

        double min_length = std::numeric_limits<double>::infinity();
        int closest_u = -1;

        // Find the closest unmatched odd vertex
        for (int j = i + 1; j < current_odd.size(); ++j) {
             int u = current_odd[j];
             if (!matched[u]) { // Check if 'u' is available
                 if (graph[v][u] < min_length) {
                     min_length = graph[v][u];
                     closest_u = u;
                 }
             }
        }

        if (closest_u != -1) {
            // Add the matching edge to the MST list (now a multigraph)
            mst.push_back({v, closest_u, min_length});
            matched[v] = true;
            matched[closest_u] = true; // Mark both as matched
        }
        // Note: In a perfect matching on an even number of vertices,
        // every vertex should find a match. If closest_u remains -1,
        // something is wrong (e.g., odd number of odd_vertices input?)
        // Christofides guarantees an even number of odd-degree vertices.
    }
}


// --- Find Eulerian Tour (Hierholzer's Algorithm) ---
std::vector<int> find_eulerian_tour(const std::vector<Edge>& matched_mst, int n) {
    if (matched_mst.empty()) return {};

    // Build adjacency list representation of the multigraph (MST + matching)
    // Use std::list for efficient removal of edges during tour construction
    std::vector<std::list<std::pair<int, const Edge*>>> adj(n); // Store neighbor and pointer to original edge
    std::map<const Edge*, bool> edge_used; // Track used edges (since multigraph)

    for (const auto& edge : matched_mst) {
        adj[edge.u].push_back({edge.v, &edge});
        adj[edge.v].push_back({edge.u, &edge});
        edge_used[&edge] = false;
    }

    std::vector<int> tour;
    std::stack<int> current_path;

    // Start at any vertex with edges (e.g., the first vertex of the first edge)
    int start_node = matched_mst[0].u;
    current_path.push(start_node);
    int current_node = start_node;

    while (!current_path.empty()) {
        current_node = current_path.top();
        bool found_edge = false;

        // Find an unused edge from the current node
        for (auto it = adj[current_node].begin(); it != adj[current_node].end(); ) {
            int neighbor = it->first;
            const Edge* edge_ptr = it->second;

            if (!edge_used[edge_ptr]) {
                edge_used[edge_ptr] = true; // Mark edge as used

                // Push neighbor onto stack and move to it
                current_path.push(neighbor);

                // Remove the edge from the neighbor's list as well
                // This part is tricky with pointers; let's simplify
                // by just relying on the edge_used map. A more robust
                // Hierholzer implementation might store iterators.
                 // We don't strictly need to remove from adj list if using edge_used map

                found_edge = true;
                break; // Move to the neighbor
            } else {
                 ++it; // Check next edge
            }
        }


        // If no unused edge was found from current_node, backtrack
        if (!found_edge) {
            tour.push_back(current_path.top());
            current_path.pop();
        }
    }

    // The tour is constructed in reverse order
    std::reverse(tour.begin(), tour.end());
    return tour;
}


// --- Main TSP Function (Christofides Approximation) ---
std::pair<double, std::vector<int>> tsp(const std::vector<Point>& data) {
    int n = data.size();
    if (n == 0) {
        return {0.0, {}};
    }
    if (n == 1) {
        return {0.0, {data[0].id}}; // Or just {0} if using 0-based indexing internally
    }

    // Build a graph
    std::vector<std::vector<double>> G = build_graph(data);
    print_graph(G, "Graph");

    // Build a minimum spanning tree
    std::vector<Edge> MSTree = minimum_spanning_tree(G);
    print_edges(MSTree, "MSTree");

    // Find odd degree vertices
    std::vector<int> odd_vertexes = find_odd_vertexes(MSTree, n);
    print_container(odd_vertexes, "Odd vertexes in MSTree");

    // Add minimum weight matching edges (using greedy heuristic)
    // Note: This modifies MSTree, turning it into a multigraph representation
    minimum_weight_matching(MSTree, G, odd_vertexes);
    print_edges(MSTree, "Minimum weight matching (MST + Matching Edges)"); // Now contains MST + Matching

    // Find an Eulerian tour in the combined graph
    std::vector<int> eulerian_tour = find_eulerian_tour(MSTree, n);
    print_container(eulerian_tour, "Eulerian tour");

    // --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    if (eulerian_tour.empty()) {
         std::cerr << "Error: Eulerian tour could not be found." << std::endl;
         return {-1.0, {}}; // Indicate error
    }

    std::vector<int> path;
    double length = 0.0;
    std::vector<bool> visited(n, false);

    int current = eulerian_tour[0];
    path.push_back(current);
    visited[current] = true;

    for (size_t i = 1; i < eulerian_tour.size(); ++i) {
        int v = eulerian_tour[i];
        if (!visited[v]) {
            path.push_back(v);
            visited[v] = true;
            length += G[current][v]; // Add distance from previous node in path
            current = v; // Update current node in path
        }
    }

    // Add the edge back to the start
    length += G[current][path[0]];
    path.push_back(path[0]); // Complete the cycle

    // Convert path indices back to original IDs if needed (assuming Point.id holds them)
    // If the input 'data' vector's order corresponds to IDs 0..N-1, no conversion is needed.
    // If Point.id was used differently, you'd map back here.

    print_container(path, "Result path");
    std::cout << "Result length of the path: " << std::fixed << std::setprecision(2) << length << std::endl;

    return {length, path};
}


int main() {
    // Input data matching the Python example
    // Store as Point structs, retaining original order implicitly as ID 0..N-1
    std::vector<std::pair<double, double>> raw_data = {
        {1380, 939}, {2848, 96}, {3510, 1671}, {457, 334}, {3888, 666}, {984, 965}, {2721, 1482}, {1286, 525},
        {2716, 1432}, {738, 1325}, {1251, 1832}, {2728, 1698}, {3815, 169}, {3683, 1533}, {1247, 1945}, {123, 862},
        {1234, 1946}, {252, 1240}, {611, 673}, {2576, 1676}, {928, 1700}, {53, 857}, {1807, 1711}, {274, 1420},
        {2574, 946}, {178, 24}, {2678, 1825}, {1795, 962}, {3384, 1498}, {3520, 1079}, {1256, 61}, {1424, 1728},
        {3913, 192}, {3085, 1528}, {2573, 1969}, {463, 1670}, {3875, 598}, {298, 1513}, {3479, 821}, {2542, 236},
        {3955, 1743}, {1323, 280}, {3447, 1830}, {2936, 337}, {1621, 1830}, {3373, 1646}, {1393, 1368},
        {3874, 1318}, {938, 955}, {3022, 474}, {2482, 1183}, {3854, 923}, {376, 825}, {2519, 135}, {2945, 1622},
        {953, 268}, {2628, 1479}, {2097, 981}, {890, 1846}, {2139, 1806}, {2421, 1007}, {2290, 1810}, {1115, 1052},
        {2588, 302}, {327, 265}, {241, 341}, {1917, 687}, {2991, 792}, {2573, 599}, {19, 674}, {3911, 1673},
        {872, 1559}, {2863, 558}, {929, 1766}, {839, 620}, {3893, 102}, {2178, 1619}, {3822, 899}, {378, 1048},
        {1178, 100}, {2599, 901}, {3416, 143}, {2961, 1605}, {611, 1384}, {3113, 885}, {2597, 1830}, {2586, 1286},
        {161, 906}, {1429, 134}, {742, 1025}, {1625, 1651}, {1187, 706}, {1787, 1009}, {22, 987}, {3640, 43},
        {3756, 882}, {776, 392}, {1724, 1642}, {198, 1810}, {3950, 1558}
    };

    std::vector<Point> data_points;
    data_points.reserve(raw_data.size());
    for(int i = 0; i < raw_data.size(); ++i) {
        data_points.push_back({raw_data[i].first, raw_data[i].second, i});
    }


    tsp(data_points);

    return 0;
}
