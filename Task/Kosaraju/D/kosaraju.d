import std.container.array;
import std.stdio;

/* the list index is the first vertex in the edge(s) */
auto g = [
    [1],
    [2],
    [0],
    [1, 2, 4],
    [3, 5],
    [2, 6],
    [5],
    [4, 6, 7],
];

int[] kosaraju(int[][] g) {
    // 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    auto size = g.length; // all false by default
    Array!bool vis;
    vis.length = size;
    int[] l;              // all zero by default
    l.length = size;
    auto x = size;        // index for filling l in reverse order
    int[][] t;            // transpose graph
    t.length = size;

    // Recursive subroutine 'visit':
    void visit(int u) {
        if (!vis[u]) {
            vis[u] = true;
            foreach (v; g[u]) {
                visit(v);
                t[v] ~= u;  // construct transpose
            }
            l[--x] = u;
        }
     }

    // 2. For each vertex u of the graph do visit(u)
    foreach (u, _; g) {
        visit(u);
    }
    int[] c;  // used for component assignment
    c.length = size;

    // Recursive subroutine 'assign':
    void assign(int u, int root) {
        if (vis[u]) {  // repurpose vis to mean 'unassigned'
            vis[u] = false;
            c[u] = root;
            foreach(v; t[u]) {
                assign(v, root);
            }
        }
    }

    // 3: For each element u of l in order, do assign(u, u)
    foreach (u; l) {
        assign(u, u);
    }

    return c;
}

void main() {
    writeln(kosaraju(g));
}
