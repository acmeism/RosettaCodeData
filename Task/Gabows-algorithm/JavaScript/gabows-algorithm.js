/**
 * Basic Directed Graph class using adjacency lists.
 * Vertices are assumed to be integers from 0 to V-1.
 */
class Digraph {
    #V; // Number of vertices (private)
    #E; // Number of edges (private)
    #adj; // Adjacency lists (private)

    /**
     * Initializes an empty digraph with V vertices.
     * @param {number} V - The number of vertices.
     */
    constructor(V) {
        if (V < 0) {
            throw new Error("Number of vertices must be non-negative");
        }
        this.#V = V;
        this.#E = 0;
        // Use an array of arrays for adjacency lists
        this.#adj = Array.from({ length: V }, () => []);
    }

    /**
     * Returns the number of vertices.
     * @returns {number}
     */
    get V() {
        return this.#V;
    }

    /**
     * Returns the number of edges.
     * @returns {number}
     */
    get E() {
        return this.#E;
    }

    /**
     * Throws Error if v is not a valid vertex.
     * @param {number} v - The vertex to validate.
     * @private
     */
    #validateVertex(v) {
        if (v < 0 || v >= this.#V) {
            throw new Error(`vertex ${v} is not between 0 and ${this.#V - 1}`);
        }
    }

    /**
     * Adds the directed edge v->w to the digraph.
     * @param {number} v - The source vertex.
     * @param {number} w - The target vertex.
     */
    addEdge(v, w) {
        this.#validateVertex(v);
        this.#validateVertex(w);
        this.#adj[v].push(w);
        this.#E++;
    }

    /**
     * Returns the list of neighbors adjacent from vertex v.
     * @param {number} v - The vertex.
     * @returns {number[]} - An array of adjacent vertices.
     */
    adj(v) {
        this.#validateVertex(v);
        return this.#adj[v]; // Return a copy if mutation is a concern: [...this.#adj[v]]
    }

    /**
     * String representation of the digraph.
     * @returns {string}
     */
    toString() {
        let s = `${this.#V} vertices, ${this.#E} edges\n`;
        for (let v = 0; v < this.#V; v++) {
            s += `${v}: ${this.#adj[v].join(' ')}\n`;
        }
        return s;
    }
}

/**
 * Computes strongly connected components (SCCs) in a digraph
 * using Gabow's algorithm.
 */
class GabowSCC {
    #marked;      // marked[v] = has v been visited? (boolean array)
    #id;          // id[v] = id of strong component containing v (number array)
    #preorder;    // preorder[v] = preorder of v (number array)
    #preCounter;  // preorder number counter (number)
    #sccCount;    // number of strongly-connected components (number)
    #stack1;      // Stores vertices in order of visitation (number array)
    #stack2;      // Auxiliary stack for finding SCC roots (number array)
    #graphV;      // Store graph's vertex count for validation

    /**
     * Computes the strong components of the digraph G.
     * @param {Digraph} G - The Digraph object.
     */
    constructor(G) {
        const V = G.V;
        this.#graphV = V;
        this.#marked = Array(V).fill(false);
        this.#id = Array(V).fill(-1);
        this.#preorder = Array(V).fill(-1);
        this.#preCounter = 0;
        this.#sccCount = 0;
        this.#stack1 = [];
        this.#stack2 = [];

        for (let v = 0; v < V; v++) {
            if (!this.#marked[v]) {
                this.#dfs(G, v);
            }
        }
        // Optional: Add a check function if needed (would require a TransitiveClosure implementation)
        // assert this.#check(G);
    }

    /**
     * Depth First Search core logic for Gabow's algorithm.
     * @param {Digraph} G - The graph.
     * @param {number} v - The current vertex.
     * @private
     */
    #dfs(G, v) {
        this.#marked[v] = true;
        this.#preorder[v] = this.#preCounter++;
        this.#stack1.push(v);
        this.#stack2.push(v);

        for (const w of G.adj(v)) {
            if (!this.#marked[w]) {
                this.#dfs(G, w);
            }
            // If w is visited but not yet assigned to an SCC,
            // it means w is on the current DFS path (or in an SCC already processed
            // in this DFS branch, but stack2 handles this).
            else if (this.#id[w] === -1) {
                // Pop vertices from stack2 until top has preorder number <= preorder[w]
                // This maintains the invariant that stack2 contains a path of potential SCC roots
                while (this.#stack2.length > 0 && this.#preorder[this.#stack2[this.#stack2.length - 1]] > this.#preorder[w]) {
                    this.#stack2.pop();
                }
            }
        }

        // If v is the root of an SCC (i.e., it remains on top of stack2 after
        // exploring all its descendants and back-edges)
        if (this.#stack2.length > 0 && this.#stack2[this.#stack2.length - 1] === v) {
            this.#stack2.pop();
            // Pop vertices from stack1 until v is popped; assign them the current SCC id
            let w;
            do {
                w = this.#stack1.pop();
                 if (w === undefined) { // Should not happen in correct execution
                    throw new Error("Error in Gabow's Algorithm: Stack1 became unexpectedly empty.");
                 }
                this.#id[w] = this.#sccCount;
            } while (w !== v);
            this.#sccCount++;
        }
    }

    /**
     * Returns the number of strong components.
     * @returns {number}
     */
    count() {
        return this.#sccCount;
    }

    /**
     * Throws Error if v is not a valid vertex for the original graph.
     * @param {number} v - The vertex to validate.
     * @private
     */
    #validateVertex(v) {
        if (v < 0 || v >= this.#graphV) {
            throw new Error(`vertex ${v} is not between 0 and ${this.#graphV - 1}`);
        }
    }

    /**
     * Are vertices v and w in the same strong component?
     * @param {number} v - one vertex
     * @param {number} w - the other vertex
     * @returns {boolean} - True if v and w are in the same strong component, False otherwise
     */
    stronglyConnected(v, w) {
        this.#validateVertex(v);
        this.#validateVertex(w);
        // If either vertex wasn't visited (e.g., in a disconnected graph part),
        // its id will be -1, and they cannot be strongly connected unless
        // the graph is empty or has isolated vertices (handled by id comparison).
        return this.#id[v] !== -1 && this.#id[v] === this.#id[w];
    }

    /**
     * Returns the component id of the strong component containing vertex v.
     * @param {number} v - the vertex
     * @returns {number} - The component id (an integer >= 0) or -1 if vertex is invalid/not reached.
     */
    getId(v) {
        this.#validateVertex(v);
        return this.#id[v];
    }

    // The _check method from Java requires a TransitiveClosure implementation.
    // For simplicity, it's omitted here, but could be added if needed.
    // #check(G) { ... }
}

// --- Main execution block ---

// --- Manually construct the digraph ---
// Example graph (based on Sedgewick/Wayne algs4 tinyDG.txt)
// 13 vertices, 22 edges
// Edges: 4->2, 2->3, 3->2, 6->0, 0->1, 2->0, 11->12, 12->9, 9->10,
//        9->11, 8->9, 10->12, 0->5, 5->4, 3->5, 6->4, 6->9, 7->6,
//        7->8, 8->7, 5->3, 0->6 (Added 0->6 to connect 0-1 and 0-5-4-2-3 cycles more directly)

const numVertices = 13;
const g = new Digraph(numVertices);

const edges = [
    [4, 2], [2, 3], [3, 2], [6, 0], [0, 1], [2, 0], [11, 12],
    [12, 9], [9, 10], [9, 11], [8, 9], [10, 12], [0, 5], [5, 4],
    [3, 5], [6, 4], [6, 9], [7, 6], [7, 8], [8, 7], [5, 3], [0, 6]
];

for (const [v, w] of edges) {
    g.addEdge(v, w);
}

console.log("Constructed Digraph:");
console.log(g.toString());

// --- Compute SCCs ---
const scc = new GabowSCC(g);

// --- Print results ---
const m = scc.count();
console.log(`\n${m} strongly connected components`);

// Group vertices by component ID
const components = Array.from({ length: m }, () => []);
for (let v = 0; v < g.V; v++) {
    const componentId = scc.getId(v);
    if (componentId !== -1) { // Should always be >= 0 after running constructor
         components[componentId].push(v);
    } else {
         // This case should ideally not happen if all vertices are reachable
         // or handled correctly in the init loop. Could represent isolated vertices
         // or issues if the graph was modified after SCC computation.
         console.warn(`Warning: Vertex ${v} has no SCC ID assigned.`);
    }
}

console.log("\nComponents:");
for (let i = 0; i < m; i++) {
    console.log(`Component ${i}: ${components[i].join(' ')}`);
}

// --- Example usage of stronglyConnected and getId ---
console.log("\nConnectivity checks:");
console.log(`Vertices 0 and 3 strongly connected? ${scc.stronglyConnected(0, 3)}`); // Should be True
console.log(`Vertices 0 and 7 strongly connected? ${scc.stronglyConnected(0, 7)}`); // Should be False
console.log(`Vertices 9 and 12 strongly connected? ${scc.stronglyConnected(9, 12)}`); // Should be True
console.log(`ID of vertex 5: ${scc.getId(5)}`);
console.log(`ID of vertex 8: ${scc.getId(8)}`);
