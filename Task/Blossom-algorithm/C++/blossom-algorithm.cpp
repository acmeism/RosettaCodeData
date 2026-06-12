#include <iostream>
#include <vector>
#include <queue>
#include <algorithm>

using namespace std;

struct Blossom {
    int n;
    const vector<vector<int>>& adj;
    vector<int> match, p, base;
    vector<bool> used, blossom;
    queue<int> q;

    Blossom(const vector<vector<int>>& _adj)
        : n((int)_adj.size()), adj(_adj),
          match(n, -1), p(n), base(n),
          used(n), blossom(n)
    {}

    int lca(int a, int b) {
        vector<bool> used_path(n, false);
        while (true) {
            a = base[a];
            used_path[a] = true;
            if (match[a] < 0) break;
            a = p[match[a]];
        }
        while (true) {
            b = base[b];
            if (used_path[b]) return b;
            b = p[match[b]];
        }
    }

    void markPath(int v, int b, int x) {
        // mark blossom vertices on path from v to base b
        while (base[v] != b) {
            blossom[base[v]] = blossom[base[match[v]]] = true;
            p[v] = x;
            x = match[v];
            v = p[x];
        }
    }

    bool findPath(int root) {
        fill(used.begin(), used.end(), false);
        fill(p.begin(), p.end(), -1);
        for (int i = 0; i < n; ++i) base[i] = i;
        while (!q.empty()) q.pop();

        used[root] = true;
        q.push(root);

        while (!q.empty()) {
            int v = q.front(); q.pop();
            for (int u : adj[v]) {
                if (base[v] == base[u] || match[v] == u)
                    continue;
                if (u == root || (match[u] >= 0 && p[match[u]] >= 0)) {
                    // blossom found
                    int curbase = lca(v, u);
                    fill(blossom.begin(), blossom.end(), false);
                    markPath(v, curbase, u);
                    markPath(u, curbase, v);
                    for (int i = 0; i < n; ++i) {
                        if (blossom[base[i]]) {
                            base[i] = curbase;
                            if (!used[i]) {
                                used[i] = true;
                                q.push(i);
                            }
                        }
                    }
                }
                else if (p[u] < 0) {
                    // extend tree
                    p[u] = v;
                    if (match[u] < 0) {
                        // augmenting path found
                        int cur = u;
                        while (cur != -1) {
                            int prev = p[cur];
                            int nxt = (prev >= 0 ? match[prev] : -1);
                            match[cur] = prev;
                            match[prev] = cur;
                            cur = nxt;
                        }
                        return true;
                    }
                    used[match[u]] = true;
                    q.push(match[u]);
                }
            }
        }
        return false;
    }

    // Returns {match, size_of_matching}
    pair<vector<int>,int> solve() {
        int res = 0;
        for (int v = 0; v < n; ++v) {
            if (match[v] < 0 && findPath(v))
                ++res;
        }
        return { match, res };
    }
};

int main() {
    // Example: 5‑cycle (odd cycle) 0–1–2–3–4–0
    int n = 5;
    vector<pair<int,int>> edges = {{0,1},{1,2},{2,3},{3,4},{4,0}};
    vector<vector<int>> adj(n);
    for (auto& e : edges) {
        adj[e.first].push_back(e.second);
        adj[e.second].push_back(e.first);
    }

    Blossom bf(adj);
    auto [match, msize] = bf.solve();

    cout << "Maximum matching size: " << msize << "\n";
    cout << "Matched pairs:\n";
    for (int u = 0; u < n; ++u) {
        int v = match[u];
        if (v >= 0 && u < v) {
            cout << "  " << u << " – " << v << "\n";
        }
    }
    return 0;
}
