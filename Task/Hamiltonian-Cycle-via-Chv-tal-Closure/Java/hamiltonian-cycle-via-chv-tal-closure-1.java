import java.util.ArrayList;
import java.util.List;

public class Graph {
    private int n;
    private boolean[][] adj;

    public Graph(int n) {
        // Create a new graph on n vertices (0..n-1), no edges.
        this.n = n;
        this.adj = new boolean[n][n];
    }

    public Graph clone() {
        // Return a deep copy of the graph.
        Graph g2 = new Graph(this.n);
        for (int i = 0; i < n; i++) {
            System.arraycopy(this.adj[i], 0, g2.adj[i], 0, n);
        }
        return g2;
    }

    public void addEdge(int u, int v) {
        // Add an undirected edge u--v.
        if (u < 0 || u >= n || v < 0 || v >= n) {
            throw new IndexOutOfBoundsException("vertex index out of bounds");
        }
        adj[u][v] = true;
        adj[v][u] = true;
    }

    public int degree(int u) {
        // Degree of vertex u.
        int d = 0;
        for (int v = 0; v < n; v++) {
            if (adj[u][v]) d++;
        }
        return d;
    }

    public void closure() {
        // Compute the Chvátal closure in-place.
        while (true) {
            boolean added = false;
            outer:
            for (int u = 0; u < n; u++) {
                for (int v = u + 1; v < n; v++) {
                    if (!adj[u][v] && degree(u) + degree(v) >= n) {
                        addEdge(u, v);
                        added = true;
                        break outer;
                    }
                }
            }
            if (!added) break;
        }
    }

    public boolean isComplete() {
        // Is the graph complete?
        for (int u = 0; u < n; u++) {
            for (int v = u + 1; v < n; v++) {
                if (!adj[u][v]) return false;
            }
        }
        return true;
    }

    public List<Integer> hamiltonianCycle() {
        // Find a Hamiltonian cycle by simple backtracking.
        boolean[] visited = new boolean[n];
        List<Integer> path = new ArrayList<>();
        path.add(0);
        visited[0] = true;
        return dfs(0, visited, path);
    }

    private List<Integer> dfs(int u, boolean[] visited, List<Integer> path) {
        if (path.size() == n) {
            // Can we close the cycle?
            if (adj[u][path.get(0)]) {
                List<Integer> cycle = new ArrayList<>(path);
                cycle.add(path.get(0)); // close it
                return cycle;
            }
            return null;
        }
        for (int v = 0; v < n; v++) {
            if (!visited[v] && adj[u][v]) {
                visited[v] = true;
                path.add(v);
                List<Integer> cycle = dfs(v, visited, path);
                if (cycle != null) return cycle;
                // backtrack
                path.remove(path.size() - 1);
                visited[v] = false;
            }
        }
        return null;
    }

    public static void main(String[] args) {
        // Example: 5 vertices, almost complete graph missing edge 0--1.
        // This satisfies Ore's condition: deg(0)=3, deg(1)=3, 3+3>=5.
        Graph g = new Graph(5);
        // Add all edges except (0,1)
        for (int u = 0; u < 5; u++) {
            for (int v = u + 1; v < 5; v++) {
                if (!(u == 0 && v == 1)) {
                    g.addEdge(u, v);
                }
            }
        }

        System.out.println("Original graph degrees:");
        for (int u = 0; u < g.n; u++) {
            System.out.println(" deg(" + u + ") = " + g.degree(u));
        }

        // Compute closure
        Graph closure = g.clone();
        closure.closure();

        System.out.println("\nAfter Chvátal closure:");
        for (int u = 0; u < closure.n; u++) {
            List<Integer> neighbors = new ArrayList<>();
            for (int v = 0; v < closure.n; v++) {
                if (closure.adj[u][v]) {
                    neighbors.add(v);
                }
            }
            System.out.println("  " + u + ": " + neighbors);
        }

        if (closure.isComplete()) {
            System.out.println("\nClosure is complete ⇒ graph is Hamiltonian (by Bondy–Chvátal).");
            List<Integer> cycle = g.hamiltonianCycle();
            if (cycle != null) {
                System.out.print("Found Hamiltonian cycle in original graph: ");
                for (int i = 0; i < cycle.size(); i++) {
                    System.out.print(cycle.get(i) + (i + 1 < cycle.size() ? " → " : ""));
                }
                System.out.println();
            } else {
                System.out.println("Unexpected: could not find a Hamiltonian cycle.");
            }
        } else {
            System.out.println("\nClosure is not complete ⇒ no guarantee of Hamiltonian cycle.");
        }
    }
}
