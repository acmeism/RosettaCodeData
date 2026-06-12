import java.util.*;

public class Main {
    private int n;
    private List<List<Integer>> adj;
    private int[] match, p, base;
    private boolean[] used, blossom;
    private Deque<Integer> queue;

    public Main(List<List<Integer>> adj) {
        this.n = adj.size();
        this.adj = adj;
        this.match = new int[n];
        this.p = new int[n];
        this.base = new int[n];
        this.used = new boolean[n];
        this.blossom = new boolean[n];
        this.queue = new ArrayDeque<>();
        Arrays.fill(match, -1);
    }

    // Find least common ancestor of a and b in the alternating forest
    private int lca(int a, int b) {
        boolean[] usedPath = new boolean[n];
        while (true) {
            a = base[a];
            usedPath[a] = true;
            if (match[a] < 0) break;
            a = p[match[a]];
        }
        while (true) {
            b = base[b];
            if (usedPath[b]) return b;
            b = p[match[b]];
        }
    }

    // Mark vertices along the path from v to base b, setting their parent to x
    private void markPath(int v, int b, int x) {
        while (base[v] != b) {
            int mv = match[v];
            blossom[base[v]] = true;
            blossom[base[mv]] = true;
            p[v] = x;
            x = mv;
            v = p[x];
        }
    }

    // Try to find an augmenting path starting from root
    private boolean findPath(int root) {
        Arrays.fill(used, false);
        Arrays.fill(p, -1);
        for (int i = 0; i < n; i++) {
            base[i] = i;
        }
        queue.clear();

        used[root] = true;
        queue.add(root);

        while (!queue.isEmpty()) {
            int v = queue.poll();
            for (int u : adj.get(v)) {
                if (base[v] == base[u] || match[v] == u) {
                    continue;
                }
                // Blossom found
                if (u == root || (match[u] >= 0 && p[match[u]] >= 0)) {
                    int curbase = lca(v, u);
                    Arrays.fill(blossom, false);
                    markPath(v, curbase, u);
                    markPath(u, curbase, v);
                    for (int i = 0; i < n; i++) {
                        if (blossom[base[i]]) {
                            base[i] = curbase;
                            if (!used[i]) {
                                used[i] = true;
                                queue.add(i);
                            }
                        }
                    }
                } else if (p[u] < 0) {
                    // Extend the alternating tree
                    p[u] = v;
                    // Found augmenting path
                    if (match[u] < 0) {
                        int cur = u;
                        while (cur >= 0) {
                            int prev = p[cur];
                            int next = (prev >= 0 ? match[prev] : -1);
                            match[cur] = prev;
                            match[prev] = cur;
                            cur = next;
                        }
                        return true;
                    }
                    // Continue BFS from the matched partner
                    int mu = match[u];
                    if (!used[mu]) {
                        used[mu] = true;
                        queue.add(mu);
                    }
                }
            }
        }
        return false;
    }

    // Compute maximum matching; returns the size
    public int solve() {
        int res = 0;
        for (int v = 0; v < n; v++) {
            if (match[v] < 0) {
                if (findPath(v)) {
                    res++;
                }
            }
        }
        return res;
    }

    public int[] getMatch() {
        return match;
    }

    public static void main(String[] args) {
        // Example: 5‑cycle (odd cycle) 0–1–2–3–4–0
        int n = 5;
        int[][] edges = { {0,1}, {1,2}, {2,3}, {3,4}, {4,0} };
        List<List<Integer>> adj = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            adj.add(new ArrayList<>());
        }
        for (int[] e : edges) {
            adj.get(e[0]).add(e[1]);
            adj.get(e[1]).add(e[0]);
        }

        Main blossom = new Main(adj);
        int msize = blossom.solve();
        int[] match = blossom.getMatch();

        System.out.println("Maximum matching size: " + msize);
        System.out.println("Matched pairs:");
        for (int u = 0; u < n; u++) {
            int v = match[u];
            if (v >= 0 && u < v) {
                System.out.println("  " + u + " – " + v);
            }
        }
    }
}
