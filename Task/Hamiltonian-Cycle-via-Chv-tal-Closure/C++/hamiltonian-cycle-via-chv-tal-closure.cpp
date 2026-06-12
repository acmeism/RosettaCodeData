#include <iostream>
#include <vector>
#include <cassert>
#include <optional>

class Graph {
public:
    Graph(int n)
        : n_(n),
          adj_(n, std::vector<bool>(n, false))
    {}

    // Copy constructor, assignment operator: defaults are fine

    // Add an undirected edge u--v.
    void add_edge(int u, int v) {
        assert(u >= 0 && u < n_ && v >= 0 && v < n_);
        adj_[u][v] = true;
        adj_[v][u] = true;
    }

    // Degree of vertex u.
    int degree(int u) const {
        assert(u >= 0 && u < n_);
        int d = 0;
        for (bool has : adj_[u]) {
            if (has) ++d;
        }
        return d;
    }

    // Compute the Chvátal closure in-place.
    void closure() {
        while (true) {
            bool added = false;
            // Try every non-edge (u,v) with u < v
            for (int u = 0; u < n_; ++u) {
                for (int v = u + 1; v < n_; ++v) {
                    if (!adj_[u][v]) {
                        int du = degree(u);
                        int dv = degree(v);
                        if (du + dv >= n_) {
                            add_edge(u, v);
                            added = true;
                            goto NEXT_ITERATION;
                        }
                    }
                }
            }
        NEXT_ITERATION:
            if (!added) break;
        }
    }

    // Is the graph complete?
    bool is_complete() const {
        for (int u = 0; u < n_; ++u) {
            for (int v = u + 1; v < n_; ++v) {
                if (!adj_[u][v]) return false;
            }
        }
        return true;
    }

    // Find a Hamiltonian cycle in the original graph (not closure)
    // by simple backtracking. Returns a cycle as a sequence of vertices
    // starting and ending at 0, or std::nullopt if none exists.
    std::optional<std::vector<int>> hamiltonian_cycle() const {
        std::vector<bool> visited(n_, false);
        std::vector<int> path;
        path.reserve(n_);

        // fix starting vertex = 0
        visited[0] = true;
        path.push_back(0);

        auto dfs = [&](auto&& self, int u) -> std::optional<std::vector<int>> {
            if ((int)path.size() == n_) {
                // check if we can close the cycle back to 0
                if (adj_[u][path[0]]) {
                    std::vector<int> cycle = path;
                    cycle.push_back(path[0]);
                    return cycle;
                } else {
                    return std::nullopt;
                }
            }
            for (int v = 0; v < n_; ++v) {
                if (!visited[v] && adj_[u][v]) {
                    visited[v] = true;
                    path.push_back(v);
                    if (auto result = self(self, v)) {
                        return result;
                    }
                    // backtrack
                    path.pop_back();
                    visited[v] = false;
                }
            }
            return std::nullopt;
        };

        return dfs(dfs, 0);
    }

    int size() const { return n_; }
    const std::vector<std::vector<bool>>& adjacency() const { return adj_; }

private:
    int n_;
    std::vector<std::vector<bool>> adj_;
};

int main() {
    // Example: 5 vertices, almost complete graph missing edge 0--1.
    // This satisfies Ore's condition: any non-edge (0,1) has deg(0)=3, deg(1)=3, 3+3>=5.
    Graph g(5);
    // Add all edges except (0,1)
    for (int u = 0; u < 5; ++u) {
        for (int v = u + 1; v < 5; ++v) {
            if (!(u == 0 && v == 1)) {
                g.add_edge(u, v);
            }
        }
    }

    std::cout << "Original graph degrees:\n";
    for (int u = 0; u < g.size(); ++u) {
        std::cout << " deg(" << u << ") = " << g.degree(u) << "\n";
    }

    // Compute closure
    Graph closure_graph = g;  // copy
    closure_graph.closure();

    std::cout << "\nAfter Chvátal closure:\n";
    for (int u = 0; u < closure_graph.size(); ++u) {
        std::cout << "  " << u << ":";
        for (int v = 0; v < closure_graph.size(); ++v) {
            if (closure_graph.adjacency()[u][v]) {
                std::cout << " " << v;
            }
        }
        std::cout << "\n";
    }

    if (closure_graph.is_complete()) {
        std::cout << "\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).\n";
        if (auto cycle = g.hamiltonian_cycle()) {
            std::cout << "Found Hamiltonian cycle in original graph:\n";
            for (size_t i = 0; i < cycle->size(); ++i) {
                if (i > 0) std::cout << " → ";
                std::cout << (*cycle)[i];
            }
            std::cout << "\n";
        } else {
            std::cout << "Unexpected: could not find a Hamiltonian cycle.\n";
        }
    } else {
        std::cout << "\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.\n";
    }

    return 0;
}
