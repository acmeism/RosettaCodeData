// Global variable to store the found cliques
let cliques = [];

// Equivalent to the Edge struct
// (We'll just use plain objects inline)

// Helper function to print the final result (similar to print_2D_vector)
function printCliques(cliquesArray) {
    // Sort cliques before printing for consistent output
    // Sort primarily by first element, then second, etc., then by length
    cliquesArray.sort((a, b) => {
        const len = Math.min(a.length, b.length);
        for (let i = 0; i < len; i++) {
            if (a[i] < b[i]) return -1;
            if (a[i] > b[i]) return 1;
        }
        // If one is a prefix of the other, shorter comes first
        return a.length - b.length;
    });

    // Pretty print using JSON.stringify
    console.log(JSON.stringify(cliquesArray, null, 2));
}

// --- Set Operations Helpers ---

// Set Intersection: Returns a new Set containing elements present in both setA and setB
function setIntersection(setA, setB) {
    const intersection = new Set();
    for (const elem of setB) { // Iterate smaller set for potential efficiency
        if (setA.has(elem)) {
            intersection.add(elem);
        }
    }
    return intersection;
}

// Set Difference: Returns a new Set containing elements present in setA but NOT in setB (A \ B)
function setDifference(setA, setB) {
    const difference = new Set(setA); // Start with a copy of setA
    for (const elem of setB) {
        difference.delete(elem); // Remove elements found in setB
    }
    return difference;
}


/**
 * Bron-Kerbosch algorithm with pivoting to find maximal cliques.
 * @param {Set<string>} currentClique - The clique being built (R in common notation).
 * @param {Set<string>} candidates - Potential vertices to add (P).
 * @param {Set<string>} processedVertices - Vertices already processed/excluded (X).
 * @param {Map<string, Set<string>>} graph - Adjacency list representation of the graph.
 */
function bronKerbosch(currentClique, candidates, processedVertices, graph) {

    if (candidates.size === 0 && processedVertices.size === 0) {
        // Base case: Found a maximal clique
        if (currentClique.size > 2) {
            // Convert Set to Array, sort it for consistent ordering, and add to results
            const cliqueArray = Array.from(currentClique).sort();
            cliques.push(cliqueArray);
        }
        return;
    }

    // --- Pivoting ---
    // Combine candidates and processed vertices for pivot selection
    const unionSet = new Set([...candidates, ...processedVertices]);
    let pivot = '';
    let maxDegree = -1;

    // Select pivot: vertex in unionSet with the most neighbors *in candidates*
    // (Optimization: C++ version used total degree, JS version uses neighbors in candidates for better pruning)
    // Let's stick closer to the provided C++ heuristic (max degree in the *entire graph* among unionSet members) for direct translation.
     for (const u of unionSet) {
        const neighbors = graph.get(u) || new Set(); // Neighbors in the whole graph
        if (neighbors.size > maxDegree) {
             maxDegree = neighbors.size;
             pivot = u;
         }
     }

    // If unionSet was empty (should be caught by base case, but safety check)
    if (!pivot && unionSet.size > 0) {
        pivot = unionSet.values().next().value; // Fallback: pick any element if degree calc failed
    } else if (!pivot) {
        return; // Union set is truly empty
    }


    // 'possibles': Candidates that are NOT neighbors of the pivot (candidates \ N(pivot))
    const pivotNeighbors = graph.get(pivot) || new Set();
    const possibles = setDifference(candidates, pivotNeighbors); // P \ N(u)

    // --- Recursion ---
    // Iterate over a *copy* of possibles because we modify 'candidates' and 'processedVertices' below
    const possiblesCopy = Array.from(possibles);

    for (const vertex of possiblesCopy) {
        // Ensure vertex hasn't been moved from candidates in another branch's backtracking
        // (This check is usually implicitly handled by iterating the right set,
        // but explicit check can prevent errors if logic is complex)
        if (!candidates.has(vertex)) {
            continue;
        }

        const neighborsOfVertex = graph.get(vertex) || new Set();

        // Create NEW clique for recursive call: currentClique U {vertex}
        const newClique = new Set(currentClique);
        newClique.add(vertex);

        // Create NEW candidates for recursive call: candidates ∩ N(vertex)
        const newCandidates = setIntersection(candidates, neighborsOfVertex);

        // Create NEW processed vertices for recursive call: processedVertices ∩ N(vertex)
        const newProcessedVertices = setIntersection(processedVertices, neighborsOfVertex);

        // Recursive call
        bronKerbosch(newClique, newCandidates, newProcessedVertices, graph);

        // Backtracking: Move 'vertex' from candidates to processedVertices
        // Modify the sets belonging to *this* function call's scope
        candidates.delete(vertex);
        processedVertices.add(vertex);
    }
}

// --- Main Execution ---
function main() {
    const edges = [
        { start: "a", end: "b" }, { start: "b", end: "a" },
        { start: "a", end: "c" }, { start: "c", end: "a" },
        { start: "b", end: "c" }, { start: "c", end: "b" },
        { start: "d", end: "e" }, { start: "e", end: "d" },
        { start: "d", end: "f" }, { start: "f", end: "d" },
        { start: "e", end: "f" }, { start: "f", end: "e" }
    ];

    // Build the graph as an adjacency list (Map<string, Set<string>>)
    const graph = new Map();
    const allVertices = new Set(); // Keep track of all unique vertices

    for (const edge of edges) {
        // Ensure nodes exist in the map
        if (!graph.has(edge.start)) {
            graph.set(edge.start, new Set());
        }
        // Add edge
        graph.get(edge.start).add(edge.end);

        // Keep track of all vertices encountered
        allVertices.add(edge.start);
        allVertices.add(edge.end); // Ensure end node is also tracked if it never starts an edge
    }

    // Ensure all nodes mentioned (even if only as end nodes) exist as keys in the graph map
    for(const vertex of allVertices) {
         if (!graph.has(vertex)) {
            graph.set(vertex, new Set());
        }
    }


    // Initialize sets for the algorithm
    const initialCurrentClique = new Set();
    // Candidates are initially all vertices in the graph
    const initialCandidates = new Set(allVertices);
    const initialProcessedVertices = new Set();

    // Reset global cliques array before running
    cliques = [];

    // Execute the Bron-Kerbosch algorithm
    bronKerbosch(
        initialCurrentClique,
        initialCandidates,
        initialProcessedVertices,
        graph
    );

    // Display the cliques (sorted)
    printCliques(cliques);
}

// Run the main function
main();
