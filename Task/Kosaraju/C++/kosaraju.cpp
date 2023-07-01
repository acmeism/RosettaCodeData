#include <functional>
#include <iostream>
#include <ostream>
#include <vector>

template<typename T>
std::ostream& operator<<(std::ostream& os, const std::vector<T>& v) {
    auto it = v.cbegin();
    auto end = v.cend();

    os << "[";
    if (it != end) {
        os << *it;
        it = std::next(it);
    }
    while (it != end) {
        os << ", " << *it;
        it = std::next(it);
    }
    return os << "]";
}

std::vector<int> kosaraju(std::vector<std::vector<int>>& g) {
    // 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    auto size = g.size();
    std::vector<bool> vis(size);           // all false by default
    std::vector<int> l(size);              // all zero by default
    auto x = size;                         // index for filling l in reverse order
    std::vector<std::vector<int>> t(size); // transpose graph

    // Recursive subroutine 'visit':
    std::function<void(int)> visit;
    visit = [&](int u) {
        if (!vis[u]) {
            vis[u] = true;
            for (auto v : g[u]) {
                visit(v);
                t[v].push_back(u); // construct transpose
            }
            l[--x] = u;
        }
    };

    // 2. For each vertex u of the graph do visit(u)
    for (int i = 0; i < g.size(); ++i) {
        visit(i);
    }
    std::vector<int> c(size); // used for component assignment

    // Recursive subroutine 'assign':
    std::function<void(int, int)> assign;
    assign = [&](int u, int root) {
        if (vis[u]) { // repurpose vis to mean 'unassigned'
            vis[u] = false;
            c[u] = root;
            for (auto v : t[u]) {
                assign(v, root);
            }
        }
    };

    // 3: For each element u of l in order, do assign(u, u)
    for (auto u : l) {
        assign(u, u);
    }

    return c;
}

std::vector<std::vector<int>> g = {
    {1},
    {2},
    {0},
    {1, 2, 4},
    {3, 5},
    {2, 6},
    {5},
    {4, 6, 7},
};

int main() {
    using namespace std;

    cout << kosaraju(g) << endl;

    return 0;
}
