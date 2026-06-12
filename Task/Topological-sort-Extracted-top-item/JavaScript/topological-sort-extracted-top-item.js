// Helper function to print an array like C++ print_vector
function printVector(vec) {
  // Use process.stdout.write to mimic std::cout without automatic newline
  process.stdout.write(`[${vec.join(', ')}]`);
  console.log(); // Add the newline explicitly like std::endl
}

// Helper function to print a Set like C++ print_set (sorted)
function printSet(aSet) {
  // Convert Set to Array, sort it (like std::set), and join
  const sortedArray = [...aSet].sort();
  process.stdout.write(sortedArray.join(', '));
  // No newline here, matching C++ print_set behavior before std::endl
}

// Helper function specifically for inline printing needed in main
function printSetInline(aSet) {
    const sortedArray = [...aSet].sort();
    process.stdout.write(sortedArray.join(', '));
}


/**
 * Return the top levels of the dependency graph.
 * Top levels are nodes that are not dependencies of any other node in the graph.
 * @param {Map<string, Set<string>>} data - The dependency graph. Keys are nodes, values are sets of their dependencies.
 * @returns {Set<string>} - A set containing the names of the top-level nodes.
 */
function getTopLevels(data) {
    // Note: Unlike the C++ version which modifies the input map's sets by reference
    // inside the loop (a potential side effect), this JS version calculates
    // dependencies without modifying the original data structure.

    const allDependencies = new Set();
    const allKeys = new Set();

    for (const [key, valueSet] of data.entries()) {
        allKeys.add(key);
        // Create a temporary set excluding potential self-dependency for dependency collection
        const dependenciesOnly = new Set(valueSet);
        dependenciesOnly.delete(key); // Remove self-dependency if present
        for (const dependency of dependenciesOnly) {
            allDependencies.add(dependency);
        }
    }

    const result = new Set();
    for (const key of allKeys) {
        // A key is a top level if it's not present in the set of all dependencies
        if (!allDependencies.has(key)) {
            result.add(key);
        }
    }

    return result;
}

/**
 * Return the set of items starting from 'tops' in topological order layers.
 * @param {Map<string, Set<string>>} data - The dependency graph.
 * @param {Set<string>} initialTops - The set of starting nodes.
 * @returns {string[][]} - An array of arrays, where each inner array represents a compilation layer, sorted alphabetically. Deepest dependencies are first.
 */
function extractTopologicalOrder(inputData, initialTops) {
    // Create a deep enough copy to work on, avoiding modification of the original data.
    // This mimics the C++ version taking the map by value.
    const localData = new Map();
    for (const [key, valueSet] of inputData.entries()) {
        const newSet = new Set(valueSet);
        newSet.delete(key); // Remove self-dependency from the working copy
        localData.set(key, newSet);
    }

    let currentLevelNodes = new Set(initialTops); // Start with the initial tops
    const discoveredLayers = []; // Stores sets of nodes discovered level by level (raw discovery order)

    // --- Layer Discovery Phase ---
    // Keep track of all nodes encountered during discovery to potentially detect cycles
    // (though this implementation doesn't explicitly handle them, it would infinite loop)
    // and to ensure we process dependencies correctly.
    const allDiscoveredNodes = new Set();
    initialTops.forEach(node => allDiscoveredNodes.add(node));

    while (currentLevelNodes.size > 0) {
        discoveredLayers.push(new Set(currentLevelNodes)); // Store a copy of the current level

        const nextLevelNodes = new Set();
        for (const element of currentLevelNodes) {
            if (localData.has(element)) {
                const dependencies = localData.get(element);
                for (const dep of dependencies) {
                     // Add dependency only if it hasn't been seen at all yet in this extraction
                     // This part differs slightly from C++ which adds all dependencies and
                     // filters later. Let's stick closer to C++ first.
                    nextLevelNodes.add(dep);
                    allDiscoveredNodes.add(dep); // Track all nodes involved
                }
            }
        }
        currentLevelNodes = nextLevelNodes; // Move to the next level

        // Basic cycle detection: if next level contains nodes already processed in *this specific*
        // extraction starting from initialTops, something might be wrong.
        // A more robust cycle detection would be needed for general graphs.
        // The C++ code also doesn't explicitly handle cycles.
    }


    // --- Result Reconstruction Phase ---
    // Reconstruct the order from the discovered layers, ensuring no duplicates
    // across layers and sorting each layer, matching the C++ logic.
    const resultOrder = [];
    const processedNodes = new Set(); // Tracks nodes already added to resultOrder

    // Iterate backwards through the discovered layers (deepest dependencies first)
    for (let i = discoveredLayers.length - 1; i >= 0; i--) {
        const currentLayerSet = discoveredLayers[i];
        const layerForOutput = new Set();

        // Filter out nodes already processed (placed in a deeper/later layer)
        for (const node of currentLayerSet) {
            if (!processedNodes.has(node)) {
                layerForOutput.add(node);
            }
        }

        if (layerForOutput.size > 0) {
            // Convert the unique nodes for this layer to a sorted array
            const sortedLayerArray = [...layerForOutput].sort();
            resultOrder.push(sortedLayerArray); // Add to the result (builds deepest first)

            // Add the nodes just placed in the output layer to processedNodes
            for (const node of layerForOutput) { // Add only those actually added
                processedNodes.add(node);
            }
        }
    }

    // The resultOrder is built with deepest dependencies first, which matches the C++ output.
    return resultOrder;
}

/**
 * Prints the compilation order in the specified format.
 * @param {string[][]} order - The topologically sorted layers.
 */
function printCompilationOrder(order) {
  if (order.length > 0) {
      process.stdout.write("First: ");
      // Print the vector inline (without extra newline)
      process.stdout.write(`[${order[0].join(', ')}]`);
      console.log(); // Add newline
  }
  for (let i = 1; i < order.length; ++i) {
      process.stdout.write("    Then: ");
      process.stdout.write(`[${order[i].join(', ')}]`);
      console.log(); // Add newline
  }
  console.log(); // Add the final extra newline like the C++ version
}


// --- Main Execution ---
const data = new Map([
    ["top1",  new Set(["ip1", "des1", "ip2"])],
    ["top2",  new Set(["ip2", "des1", "ip3"])],
    ["des1",  new Set(["des1a", "des1b", "des1c"])],
    ["des1a", new Set(["des1a1", "des1a2"])],
    ["des1c", new Set(["des1c1", "extra1"])],
    ["ip2",   new Set(["ip2a", "ip2b", "ip2c", "ipcommon"])],
    ["ip1",   new Set(["ip1a", "ipcommon", "extra1"])]
    // Note: Nodes that are only dependencies (e.g., "ip3", "des1a1") don't need
    // explicit entries in the map if they have no dependencies themselves.
]);

const tops = getTopLevels(data);
process.stdout.write("The top levels of the dependency graph are: ");
printSet(tops); // printSet doesn't add newline
console.log(); // Add newline like C++ std::endl
console.log(); // Add extra empty line

for (const top of tops) {
    console.log(`The compilation order for top level '${top}' is:`);
    // Pass a new Set containing just the current top
    printCompilationOrder(extractTopologicalOrder(data, new Set([top])));
}

if (tops.size > 1) {
    process.stdout.write("The compilation order for top levels '");
    printSetInline(tops); // Use the inline version without newline
    console.log("' is:"); // Finish the line and add newline
    printCompilationOrder(extractTopologicalOrder(data, tops));
}

const ip1 = "ip1";
console.log(`The compilation order for file '${ip1}' is:`);
printCompilationOrder(extractTopologicalOrder(data, new Set([ip1])));
