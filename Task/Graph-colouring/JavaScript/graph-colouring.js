// Equivalent to:
// #include <vector>
// #include <string>
const allColours = ["PINK", "ORANGE", "CYAN", "YELLOW", "RED", "GREEN", "BLUE"];

// Equivalent to:
// class Node { ... };
class Node {
    constructor(id, saturation, colour) {
        this.id = id; // Equivalent to int32_t id
        this.saturation = saturation; // Equivalent to int32_t saturation
        this.colour = colour; // Equivalent to std::string colour
        this.excludedFromSearch = false; // Equivalent to bool excluded_from_search
    }

    // The default constructor Node() : id(0), ... is handled implicitly in how we create nodes in the Map.
    // If a key doesn't exist, Map.get() returns undefined, we explicitly use Map.set() to create nodes.
}

// Equivalent to:
// int main() { ... }
function main() {
    // Equivalent to:
    // std::map<int32_t, Node, decltype([](const int32_t& a, const int32_t& b){ return a < b; })> graph;
    // In JavaScript, Map keys are ordered by insertion or can be iterated over,
    // but there's no built-in custom comparator for sorted access like std::map.
    // However, the algorithm iterates through *all* map entries to find the max saturation node,
    // so the map's internal order doesn't affect the result.
    let graph = new Map(); // Map<number, Node>

    // Equivalent to:
    // std::map<int32_t, std::set<int32_t, decltype([](const int32_t& a, const int32_t& b) { return a < b; })>, decltype([](const int32_t& a, const int32_t& b) { return a < b; })> neighbours;
    // Similar to graph, Set doesn't guarantee element order like std::set,
    // but neighbor order isn't relevant to the coloring logic.
    let neighbours = new Map(); // Map<number, Set<number>>

    // Equivalent to:
    // const std::vector<std::string> graph_representations = { ... };
    const graphRepresentations = [
        "0-1 1-2 2-0 3",
        "1-6 1-7 1-8 2-5 2-7 2-8 3-5 3-6 3-8 4-5 4-6 4-7",
        "1-4 1-6 1-8 3-2 3-6 3-8 5-2 5-4 5-8 7-2 7-4 7-6",
        "1-6 7-1 8-1 5-2 2-7 2-8 3-5 6-3 3-8 4-5 4-6 4-7"
    ];

    // Equivalent to:
    // for ( const std::string& graph_representation : graph_representations ) { ... }
    for (const graphRepresentation of graphRepresentations) {
        graph.clear();
        neighbours.clear();

        // Equivalent to:
        // std::stringstream stream(graph_representation);
        // std::string element;
        // while ( stream >> element ) { ... }
        const elements = graphRepresentation.split(/\s+/); // Split string by one or more whitespace characters
        for (const element of elements) {
            if (element === "") continue; // Skip empty strings that might result from multiple spaces

            // Equivalent to: if ( element.find("-") != std::string::npos ) { ... }
            if (element.includes("-")) {
                const parts = element.split("-");
                // Equivalent to: const int32_t id1 = element[0] - '0';
                const id1 = parseInt(parts[0], 10);
                // Equivalent to: const int32_t id2 = element[element.length() - 1] - '0';
                const id2 = parseInt(parts[parts.length - 1], 10); // Use last part, robust for potential future formats like 10-11

                // Ensure nodes exist in the graph map.
                // Equivalent to: if ( ! graph.contains(id1) ) { graph[id1] = Node(id1, 0, "NO_COLOUR"); }
                if (!graph.has(id1)) {
                    graph.set(id1, new Node(id1, 0, "NO_COLOUR"));
                }
                // C++ `Node node1 = graph[id1];` gets a *copy*. In JS, graph.get(id1) gets a *reference*.
                // We don't need to store the reference here just yet as we only needed to ensure the node exists.

                // Equivalent to: if ( ! graph.contains(id2) ) { graph[id2] = Node(id2, 0, "NO_COLOUR"); }
                if (!graph.has(id2)) {
                    graph.set(id2, new Node(id2, 0, "NO_COLOUR"));
                }
                // C++ `Node node2 = graph[id2];`

                // Ensure neighbor sets exist and add neighbors.
                // Equivalent to: neighbours[id1].emplace(id2);
                if (!neighbours.has(id1)) {
                    neighbours.set(id1, new Set()); // Equivalent to std::set<int32_t>
                }
                neighbours.get(id1).add(id2); // Equivalent to emplace

                // Equivalent to: neighbours[id2].emplace(id1);
                if (!neighbours.has(id2)) {
                    neighbours.set(id2, new Set());
                }
                neighbours.get(id2).add(id1);

            } else { // Handle isolated nodes (e.g., "3")
                // Equivalent to: const int32_t id = element[0] - '0';
                 const id = parseInt(element, 10); // Parse the whole element as an ID

                // Equivalent to: if ( ! graph.contains(id) ) { graph[id] = Node(id, 0, "NO_COLOUR"); }
                if (!graph.has(id)) {
                    graph.set(id, new Node(id, 0, "NO_COLOUR"));
                }
            }
        }

        // Graph Coloring Loop (DSatur-like heuristic)
        // Equivalent to: for ( uint64_t i = 0; i < graph.size(); ++i ) { ... }
        // This loop structure implies that each node is processed exactly once
        // because one node is marked excluded_from_search in each iteration.
        for (let i = 0; i < graph.size; ++i) {
            let maxNodeId = -1;
            let maxSaturation = -1;

            // Find the node with the maximum saturation among those not yet colored.
            // Equivalent to: for ( const auto& [key, value] : graph ) { ... }
            for (const [key, node] of graph) {
                // Equivalent to: if ( ! value.excluded_from_search && value.saturation > max_saturation ) { ... }
                // If multiple nodes have the same max saturation, the one encountered first in the map iteration order is chosen.
                if (!node.excludedFromSearch && node.saturation > maxSaturation) {
                    maxSaturation = node.saturation;
                    maxNodeId = key;
                }
            }

            // If maxNodeId is still -1, it means no unexcluded node was found.
            // This shouldn't happen until all nodes are processed due to the loop count.
            if (maxNodeId === -1) {
                 // Should only happen if the graph was empty or already fully excluded,
                 // which the outer loop count should prevent prematurely.
                 continue; // Skip this iteration if no node found.
            }

            // Find colours used by neighbours of the selected node.
            // Equivalent to: std::unordered_set<std::string> colours_used;
            const coloursUsed = new Set(); // Use Set for efficient `has` check

            // Equivalent to: for ( const int32_t& neighbour : neighbours[max_node_id] ) { ... }
            // Get the set of neighbor IDs for the selected node. Handle case where node has no neighbors entry.
            const neighborIdsOfSelected = neighbours.get(maxNodeId) || new Set();
            for (const neighbourId of neighborIdsOfSelected) {
                 // Get the neighbor node object from the graph map
                 const neighbourNode = graph.get(neighbourId);
                 // Check if the neighbor node exists in the graph and add its color to the set
                 if (neighbourNode) {
                     coloursUsed.add(neighbourNode.colour);
                 }
            }

            // Find the smallest available colour.
            // Equivalent to: std::string min_colour;
            let minColour = "";
            // Equivalent to: for ( const std::string& colour : all_colours ) { ... }
            for (const colour of allColours) {
                // Equivalent to: if ( ! colours_used.contains(colour) ) { ... }
                if (!coloursUsed.has(colour)) {
                    minColour = colour;
                    break; // Found the first available colour, stop searching.
                }
            }

            // Assign colour to the selected node and mark it as excluded.
            // Equivalent to: graph[max_node_id].excluded_from_search = true;
            // Equivalent to: graph[max_node_id].colour = min_colour;
            const selectedNode = graph.get(maxNodeId); // Get the reference to the node object
            selectedNode.excludedFromSearch = true;
            selectedNode.colour = minColour;

            // Update saturation of neighbours.
            // Equivalent to: for ( int32_t neighbour : neighbours[max_node_id] ) { ... }
             for (const neighbourId of neighborIdsOfSelected) {
                 const neighbourNode = graph.get(neighbourId);
                 // Equivalent to: if ( graph[neighbour].colour == "NO_COLOUR" ) { ... }
                 // C++ logic: only update saturation if the neighbour is still uncolored.
                 // Set saturation to the number of *distinct colors* used by the *selected node's* neighbors
                 // *at the moment the selected node was processed*.
                 if (neighbourNode && neighbourNode.colour === "NO_COLOUR") {
                      neighbourNode.saturation = coloursUsed.size; // Uses the size calculated above
                 }
             }
             // Note: This saturation update logic is a direct translation of the C++ code.
             // A more standard DSatur might update saturation differently (e.g., incrementing
             // the saturation of *all* uncolored neighbors if the newly assigned color is new to *their* neighborhood).
             // We adhere to the C++ code's exact implementation.
        }

        // Output the results for the colored graph.
        // Equivalent to: std::unordered_set<std::string> graph_colours;
        const graphColours = new Set(); // Use Set to count unique colors

        // Equivalent to: for ( const auto& [key, value] : graph ) { ... }
        // Iterate over the graph map which now contains the final colored nodes.
        for (const [key, node] of graph) {
            // Equivalent to: graph_colours.emplace(value.colour);
            graphColours.add(node.colour);

            // Equivalent to: std::cout << "Node " << key << ":   colour = " + value.colour;
            let output = `Node ${key}:   colour = ${node.colour}`;

            // Equivalent to: if ( ! neighbours[key].empty() ) { ... }
             const neighborIds = neighbours.get(key) || new Set(); // Get neighbors for the current node key
            if (neighborIds.size > 0) {
                // Equivalent to: std::cout << std::string(8 - value.colour.length(), ' ') << "neighbours = ";
                // Calculate padding for alignment based on C++ padding (8 - color length)
                const padding = ' '.repeat(Math.max(0, 8 - node.colour.length));
                output += `${padding}neighbours = `;

                // Equivalent to: for ( const int32_t& neighbour : neighbours[key] ) { std::cout << neighbour << " "; }
                // Convert the Set of neighbor IDs to an Array and join them with spaces.
                 const neighborList = Array.from(neighborIds).join(" ");
                output += neighborList;
            }
            // Equivalent to: std::cout << std::endl;
            console.log(output);
        }
        // Equivalent to: std::cout << "Number of colours used: " << graph_colours.size() << std::endl << std::endl;
        console.log(`Number of colours used: ${graphColours.size}`);
        console.log(""); // Add an extra newline as in the C++ output
    }
}

// Execute the main function
main();
