function printCircuit(adj) {
    // adj represents the adjacency list of the directed graph
    // edge_count represents the number of edges emerging from a vertex
    let edge_count = new Map();

    // Initialize edge count for each vertex
    for (let i = 0; i < adj.length; i++) {
        edge_count.set(i, adj[i].length);
    }

    if (!adj.length) {
        return; // empty graph
    }

    // Maintain a stack to keep vertices
    let curr_path = [];

    // Array to store final circuit
    let circuit = [];

    // Start from vertex 0
    curr_path.push(0);
    let curr_v = 0; // Current vertex

    while (curr_path.length > 0) {
        // If there's remaining edge
        if (edge_count.get(curr_v) > 0) {
            // Push the vertex
            curr_path.push(curr_v);

            // Find the next vertex using an edge
            let next_v = adj[curr_v][adj[curr_v].length - 1];

            // Remove that edge
            edge_count.set(curr_v, edge_count.get(curr_v) - 1);
            adj[curr_v].pop();

            // Move to next vertex
            curr_v = next_v;
        }
        // Back-track to find remaining circuit
        else {
            circuit.push(curr_v);

            // Back-tracking
            curr_v = curr_path[curr_path.length - 1];
            curr_path.pop();
        }
    }

    // Print the circuit in reverse
    let result = "";
    for (let i = circuit.length - 1; i >= 0; i--) {
        result += circuit[i];
        if (i > 0) {
            result += " -> ";
        }
    }
    console.log(result);
}

// Test the function
function main() {
    // First adjacency list
    let adj1 = new Array(3);
    for (let i = 0; i < adj1.length; i++) {
        adj1[i] = [];
    }

    // Build the edges
    adj1[0].push(1);
    adj1[1].push(2);
    adj1[2].push(0);
    printCircuit(adj1);

    // Second adjacency list
    let adj2 = new Array(7);
    for (let i = 0; i < adj2.length; i++) {
        adj2[i] = [];
    }

    adj2[0].push(1);
    adj2[0].push(6);
    adj2[1].push(2);
    adj2[2].push(0);
    adj2[2].push(3);
    adj2[3].push(4);
    adj2[4].push(2);
    adj2[4].push(5);
    adj2[5].push(0);
    adj2[6].push(4);
    printCircuit(adj2);
}

// Run the program
main();
