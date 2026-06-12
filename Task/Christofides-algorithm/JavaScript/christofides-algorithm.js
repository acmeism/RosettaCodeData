// --- Helper Structs (using Objects) ---
// Point: { x: number, y: number, id: number }
// Edge: { u: number, v: number, weight: number, id?: number } // id added for Eulerian tour

// --- Helper Functions ---

function printContainer(container, name) {
    console.log(`${name}: [${container.join(', ')}]`);
}

function printEdges(edges, name) {
    const edgeStrings = edges.map(e => `(${e.u}, ${e.v}, ${e.weight.toFixed(2)})`);
    console.log(`${name}: [${edgeStrings.join(', ')}]`);
}

function printGraph(graph, name) {
    console.log(`${name}: {`);
    const n = graph.length;
    for (let i = 0; i < n; i++) {
        const entries = [];
        for (let j = 0; j < n; j++) {
            if (i !== j) {
                entries.push(`${j}: ${graph[i][j].toFixed(2)}`);
            }
        }
        console.log(`  ${i}: {${entries.join(', ')}}${i === n - 1 ? '' : ','}`);
    }
    console.log(`}`);
}


// --- Euclidean Distance ---
function getLength(p1, p2) {
    const dx = p1.x - p2.x;
    const dy = p1.y - p2.y;
    return Math.sqrt(dx * dx + dy * dy);
}

// --- Build Complete Graph (Adjacency Matrix) ---
function buildGraph(data) {
    const n = data.length;
    // Initialize n x n array with 0s
    const graph = Array(n).fill(0).map(() => Array(n).fill(0.0));
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) { // Only calculate upper triangle
            const dist = getLength(data[i], data[j]);
            graph[i][j] = dist;
            graph[j][i] = dist; // Symmetric graph
        }
    }
    return graph;
}

// --- Union-Find Data Structure ---
class UnionFind {
    constructor(n) {
        // Initialize parent array: each node is its own parent
        this.parent = Array.from({ length: n }, (_, i) => i);
        // Initialize rank (or size) array for optimization
        this.rank = Array(n).fill(0);
    }

    find(i) {
        if (this.parent[i] === i) {
            return i;
        }
        // Path compression: point directly to the root
        this.parent[i] = this.find(this.parent[i]);
        return this.parent[i];
    }

    unite(i, j) {
        let rootI = this.find(i);
        let rootJ = this.find(j);
        if (rootI !== rootJ) {
            // Union by rank: attach smaller rank tree under larger rank tree
            if (this.rank[rootI] < this.rank[rootJ]) {
                this.parent[rootI] = rootJ;
            } else if (this.rank[rootI] > this.rank[rootJ]) {
                this.parent[rootJ] = rootI;
            } else {
                // Ranks are equal, choose one as parent and increment its rank
                this.parent[rootJ] = rootI;
                this.rank[rootI]++;
            }
            return true; // Successfully united
        }
        return false; // Already in the same set
    }
}

// --- Minimum Spanning Tree (Kruskal's Algorithm) ---
function minimumSpanningTree(graph) {
    const n = graph.length;
    if (n === 0) return [];

    const edges = [];
    for (let i = 0; i < n; i++) {
        for (let j = i + 1; j < n; j++) { // Avoid duplicates and self-loops
            edges.push({ u: i, v: j, weight: graph[i][j] });
        }
    }

    // Sort edges by weight in ascending order
    edges.sort((a, b) => a.weight - b.weight);

    const mst = [];
    const uf = new UnionFind(n);
    let edgesCount = 0;

    for (const edge of edges) {
        if (uf.unite(edge.u, edge.v)) { // If uniting forms a new connection
            mst.push(edge);
            edgesCount++;
            if (edgesCount === n - 1) { // Optimization: MST has n-1 edges
                break;
            }
        }
    }
    return mst;
}

// --- Find Vertices with Odd Degree in MST ---
function findOddVertexes(mst, n) {
    const degree = Array(n).fill(0);
    for (const edge of mst) {
        degree[edge.u]++;
        degree[edge.v]++;
    }

    const oddVertices = [];
    for (let i = 0; i < n; i++) {
        if (degree[i] % 2 !== 0) {
            oddVertices.push(i);
        }
    }
    return oddVertices;
}

// --- Minimum Weight Matching (Greedy Heuristic) ---
// Fisher-Yates (Knuth) Shuffle algorithm
function shuffleArray(array) {
    for (let i = array.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [array[i], array[j]] = [array[j], array[i]]; // ES6 swap
    }
}

// Note: This modifies the mst array by adding matching edges.
function minimumWeightMatching(mst, graph, oddVertices) {
    // Shuffle for randomness (like the Python version)
    shuffleArray(oddVertices);

    const matched = new Set(); // Keep track of vertices already matched in this phase

    for (let i = 0; i < oddVertices.length; i++) {
        const v = oddVertices[i];
        if (matched.has(v)) continue; // Skip if already matched

        let minLength = Infinity;
        let closestU = -1;

        // Find the closest *unmatched* odd vertex
        for (let j = i + 1; j < oddVertices.length; j++) {
            const u = oddVertices[j];
            if (!matched.has(u)) { // Check if 'u' is available
                if (graph[v][u] < minLength) {
                    minLength = graph[v][u];
                    closestU = u;
                }
            }
        }

        if (closestU !== -1) {
            // Add the matching edge to the MST list (now a multigraph)
            mst.push({ u: v, v: closestU, weight: minLength });
            matched.add(v);
            matched.add(closestU); // Mark both as matched
        }
        // Christofides guarantees an even number of odd-degree vertices,
        // so every vertex *should* find a match in a perfect matching scenario.
        // The greedy approach might leave some unmatched if not careful, but this loop structure should work.
    }
     // No return value needed as mst is modified directly by reference
}


// --- Find Eulerian Tour (Hierholzer's Algorithm) ---
function findEulerianTour(matchedMST, n) {
    if (matchedMST.length === 0) return [];

    // Assign unique IDs to edges for tracking in the multigraph
    // (essential because multiple edges can exist between nodes)
    matchedMST.forEach((edge, index) => edge.id = index);

    // Build adjacency list: adj[u] = [{ neighbor: v, edgeId: id }, ...]
    const adj = Array(n).fill(0).map(() => []);
    const edgeUsed = new Set(); // Store used edge IDs

    for (const edge of matchedMST) {
        adj[edge.u].push({ neighbor: edge.v, edgeId: edge.id });
        adj[edge.v].push({ neighbor: edge.u, edgeId: edge.id });
    }

    const tour = [];
    const stack = [];

    // Start at any vertex with edges (guaranteed to exist if matchedMST is not empty)
    const startNode = matchedMST[0].u;
    stack.push(startNode);
    let currentNode = startNode;

    while (stack.length > 0) {
        currentNode = stack[stack.length - 1]; // Peek top of stack

        let foundUnusedEdge = false;
        // Check outgoing edges from currentNode
        while (adj[currentNode].length > 0) {
             const edgeInfo = adj[currentNode][adj[currentNode].length - 1]; // Look at last edge (efficient removal)
             if (!edgeUsed.has(edgeInfo.edgeId)) {
                 // Found an unused edge
                 edgeUsed.add(edgeInfo.edgeId); // Mark edge as used
                 stack.push(edgeInfo.neighbor); // Push neighbor onto stack
                 adj[currentNode].pop(); // Remove edge from current node's list
                 currentNode = edgeInfo.neighbor; // Move to the neighbor
                 foundUnusedEdge = true;
                 break; // Break inner loop to process the new currentNode
             } else {
                 // This edge was already used (by traversal from the other side), remove it
                 adj[currentNode].pop();
             }
        }


        if (!foundUnusedEdge) {
            // If no unused edges from currentNode, backtrack
            tour.push(stack.pop());
        }
    }

    // The tour is constructed in reverse order by Hierholzer's
    return tour.reverse();
}


// --- Main TSP Function (Christofides Approximation) ---
function tsp(data) {
    const n = data.length;
    if (n === 0) {
        return { length: 0, path: [] };
    }
    if (n === 1) {
        // If data points have explicit IDs use them, otherwise use index 0
        const startId = data[0].id !== undefined ? data[0].id : 0;
        return { length: 0, path: [startId] };
    }

    // Assign IDs if they don't exist, assuming order corresponds to 0..n-1
    data.forEach((p, i) => { if (p.id === undefined) p.id = i; });


    console.log("Building graph...");
    const G = buildGraph(data);
    // printGraph(G, "Graph"); // Often too large to print meaningfully

    console.log("Finding Minimum Spanning Tree...");
    const MSTree = minimumSpanningTree(G);
    printEdges(MSTree, "MSTree");

    console.log("Finding odd degree vertices...");
    const odd_vertexes = findOddVertexes(MSTree, n);
    printContainer(odd_vertexes, "Odd vertexes in MSTree");

    console.log("Finding Minimum Weight Matching (greedy)...");
    // Create a new array containing MST edges to avoid modifying the original MSTree variable directly
    // The matching edges will be added to this new array.
    const multigraphEdges = [...MSTree];
     // Pass a copy of odd_vertexes as it might be shuffled in place
    minimumWeightMatching(multigraphEdges, G, [...odd_vertexes]);
    printEdges(multigraphEdges, "Minimum weight matching (MST + Matching Edges)");

    console.log("Finding Eulerian Tour...");
    const eulerian_tour = findEulerianTour(multigraphEdges, n);
    printContainer(eulerian_tour, "Eulerian tour");

    // --- Create Hamiltonian Circuit by Skipping Visited Nodes ---
    if (eulerian_tour.length === 0 && n > 0) {
        console.error("Error: Eulerian tour could not be found.");
        return { length: -1, path: [] }; // Indicate error
    }

    console.log("Creating Hamiltonian path (shortcutting)...");
    const path = [];
    let length = 0.0;
    const visited = new Set(); // Use Set for efficient O(1) average time complexity checks

    let currentPathNode = -1; // Track the last node added to the *Hamiltonian* path

    for (const node of eulerian_tour) {
        if (!visited.has(node)) {
            path.push(node);
            visited.add(node);
            if (currentPathNode !== -1) { // Add edge length from the previous node *in the path*
                length += G[currentPathNode][node];
            }
            currentPathNode = node; // Update the last node added to the path
        }
    }

    // Add the edge back to the start to complete the cycle
    if (path.length > 0) {
        length += G[currentPathNode][path[0]]; // Edge from last node in path to first node
        path.push(path[0]); // Add the starting node again to show the cycle
    }


    printContainer(path, "Result path");
    console.log(`Result length of the path: ${length.toFixed(2)}`);

    return { length: length, path: path };
}

// --- Input Data ---
const raw_data = [
    [1380, 939], [2848, 96], [3510, 1671], [457, 334], [3888, 666], [984, 965], [2721, 1482], [1286, 525],
    [2716, 1432], [738, 1325], [1251, 1832], [2728, 1698], [3815, 169], [3683, 1533], [1247, 1945], [123, 862],
    [1234, 1946], [252, 1240], [611, 673], [2576, 1676], [928, 1700], [53, 857], [1807, 1711], [274, 1420],
    [2574, 946], [178, 24], [2678, 1825], [1795, 962], [3384, 1498], [3520, 1079], [1256, 61], [1424, 1728],
    [3913, 192], [3085, 1528], [2573, 1969], [463, 1670], [3875, 598], [298, 1513], [3479, 821], [2542, 236],
    [3955, 1743], [1323, 280], [3447, 1830], [2936, 337], [1621, 1830], [3373, 1646], [1393, 1368],
    [3874, 1318], [938, 955], [3022, 474], [2482, 1183], [3854, 923], [376, 825], [2519, 135], [2945, 1622],
    [953, 268], [2628, 1479], [2097, 981], [890, 1846], [2139, 1806], [2421, 1007], [2290, 1810], [1115, 1052],
    [2588, 302], [327, 265], [241, 341], [1917, 687], [2991, 792], [2573, 599], [19, 674], [3911, 1673],
    [872, 1559], [2863, 558], [929, 1766], [839, 620], [3893, 102], [2178, 1619], [3822, 899], [378, 1048],
    [1178, 100], [2599, 901], [3416, 143], [2961, 1605], [611, 1384], [3113, 885], [2597, 1830], [2586, 1286],
    [161, 906], [1429, 134], [742, 1025], [1625, 1651], [1187, 706], [1787, 1009], [22, 987], [3640, 43],
    [3756, 882], [776, 392], [1724, 1642], [198, 1810], [3950, 1558]
];

// Convert raw data to point objects, using index as ID
const data_points = raw_data.map((coords, index) => ({
    x: coords[0],
    y: coords[1],
    id: index // Use 0-based index as the vertex ID
}));

// --- Run TSP ---
tsp(data_points);
