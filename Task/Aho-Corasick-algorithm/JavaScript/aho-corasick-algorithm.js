// Node class representing a node in the Trie/Automaton
class Node {
    constructor() {
        // son: Children nodes for 'a' through 'z'. Stores index in the main 'tr' array.
        this.son = new Array(26).fill(0);
        // ans: Count of times this node is visited during query (intermediate count)
        this.ans = 0;
        // fail: Index of the failure link node in the 'tr' array.
        this.fail = 0;
        // du: In-degree for the topological sort based on failure links.
        this.du = 0;
        // idx: Unique ID assigned if this node marks the end of a pattern (0 otherwise).
        this.idx = 0;
    }
}

// ACAutomaton class implementing the Aho-Corasick algorithm
class ACAutomaton {
    constructor(maxNodes) {
        // tr: Array storing all Node objects. tr[0] is the root.
        this.tr = new Array(maxNodes);
        for (let i = 0; i < maxNodes; i++) {
            this.tr[i] = new Node(); // Pre-allocate nodes
        }
        // tot: Total number of nodes created (index for the next new node).
        this.tot = 0; // Root is node 0, next node will be 1
        // final_ans: Array to store final counts for each pattern (indexed by pattern ID).
        this.final_ans = [];
        // pidx: Counter for assigning unique IDs to patterns.
        this.pidx = 0;
    }

    // Optional: Method to reset the automaton (if reusing the same instance)
    init() {
        const maxNodes = this.tr.length;
        this.tr = new Array(maxNodes);
        for (let i = 0; i < maxNodes; i++) {
            this.tr[i] = new Node();
        }
        this.tot = 0;
        this.pidx = 0;
        this.final_ans = [];
    }

    // Inserts a pattern into the Trie structure
    insert(pattern) {
        let u = 0; // Start at the root node
        for (let i = 0; i < pattern.length; i++) {
            const char = pattern[i];
            const charCode = char.charCodeAt(0) - 'a'.charCodeAt(0);

            // If child node for this character doesn't exist, create it
            if (this.tr[u].son[charCode] === 0) {
                this.tot++; // Increment total node count
                this.tr[u].son[charCode] = this.tot; // Link parent to new child node index
                // Note: Node object for this.tr[this.tot] was already created in constructor
            }
            // Move to the child node
            u = this.tr[u].son[charCode];
        }

        // Mark the end node of the pattern with a unique ID if it doesn't have one
        if (this.tr[u].idx === 0) {
            this.pidx++; // Increment pattern ID counter
            this.tr[u].idx = this.pidx; // Assign the ID
        }
        // Return the unique ID associated with this pattern
        return this.tr[u].idx;
    }

    // Builds the failure links using BFS
    build() {
        const q = []; // Use array as a queue (push -> enqueue, shift -> dequeue)

        // Initialize queue with children of the root
        for (let i = 0; i < 26; i++) {
            if (this.tr[0].son[i] !== 0) {
                q.push(this.tr[0].son[i]);
                // Optional: Nodes directly under root have root (0) as fail link (already default)
                // this.tr[this.tr[0].son[i]].fail = 0;
            }
        }

        while (q.length > 0) {
            const u = q.shift(); // Dequeue node index

            // Iterate through all possible characters ('a' to 'z')
            for (let i = 0; i < 26; i++) {
                const sonNodeIdx = this.tr[u].son[i];
                const failNodeIdx = this.tr[u].fail;

                if (sonNodeIdx !== 0) {
                    // If a direct child exists:
                    // Its failure link is the node reached by following the parent's
                    // failure link and then taking the same character transition.
                    this.tr[sonNodeIdx].fail = this.tr[failNodeIdx].son[i];

                    // Increment the in-degree of the node pointed to by the fail link
                    // (for the final calculation step)
                    this.tr[this.tr[sonNodeIdx].fail].du++;

                    // Enqueue the child node
                    q.push(sonNodeIdx);
                } else {
                    // If a direct child doesn't exist (son is 0):
                    // Create a "virtual" transition by pointing this character's slot
                    // to the node reached by following the parent's failure link
                    // and taking the same character transition. This optimizes the query phase.
                    this.tr[u].son[i] = this.tr[failNodeIdx].son[i];
                }
            }
        }
    }

    // Queries the text against the built automaton
    query(text) {
        let u = 0; // Start at the root
        for (let i = 0; i < text.length; i++) {
            const char = text[i];
            const charCode = char.charCodeAt(0) - 'a'.charCodeAt(0);

            // Follow the transitions (or failure links implicitly via build step)
            u = this.tr[u].son[charCode];

            // Increment the count for the current node
            this.tr[u].ans++;
             // Note: The original python code only increments tr[u].ans here.
             // If we needed to count all matches including suffixes found via fail links
             // *during* the query, we'd need another loop here:
             // let temp = u;
             // while (temp !== 0) {
             //     this.tr[temp].ans++; // Or increment a separate count
             //     temp = this.tr[temp].fail;
             // }
             // However, the provided Python code does the aggregation in calculate_final_answers.
        }
    }

    // Calculates the final counts for each pattern using failure links
    calculate_final_answers() {
        // Initialize final answer array based on the number of unique patterns found
        this.final_ans = new Array(this.pidx + 1).fill(0);
        const q = []; // Queue for topological sort

        // Find all nodes with an in-degree of 0 (start points for the sort)
        // Iterate from 0 (root) up to the last created node index
        for (let i = 0; i <= this.tot; i++) {
            if (this.tr[i].du === 0) {
                q.push(i);
            }
        }

        // Perform topological sort on the reversed failure link graph
        while (q.length > 0) {
            const u = q.shift(); // Dequeue node index

            // If this node represents the end of a pattern, store its accumulated count
            const nodeIdx = this.tr[u].idx;
            if (nodeIdx !== 0) {
                this.final_ans[nodeIdx] = this.tr[u].ans;
            }

            // Propagate the count to the node pointed to by the failure link
            const v = this.tr[u].fail;
            if (v !== undefined) { // Check if fail link exists (root's fail is 0)
                 this.tr[v].ans += this.tr[u].ans;

                 // Decrease the in-degree of the fail link node
                 this.tr[v].du--;

                 // If the fail link node's in-degree becomes 0, enqueue it
                 if (this.tr[v].du === 0) {
                    q.push(v);
                 }
            }
        }
    }
}

// --- Main Execution ---
const MAX_NODES = 200000 + 6;
// const MAX_N = 200000 + 6; // Not strictly needed with dynamic arrays

const ac = new ACAutomaton(MAX_NODES);
const n = 5;
const pattern_end_node_ids = new Array(n + 1).fill(0); // Using 1-based indexing like Python example

// Input data (hardcoded as per the example)
const my_input = ["a", "bb", "aa", "abaa", "abaaa"];
const text = "abaaabaa";

console.log("Inserting patterns...");
// Insert patterns and store their unique IDs
for (let i = 1; i <= n; i++) {
    const pattern = my_input[i - 1]; // Adjust index for 0-based my_input
    pattern_end_node_ids[i] = ac.insert(pattern);
    // console.log(`Inserted "${pattern}", assigned ID: ${pattern_end_node_ids[i]}`);
}

console.log("Building failure links...");
ac.build();

console.log("Querying text...");
ac.query(text);

console.log("Calculating final answers...");
ac.calculate_final_answers();

console.log("Results:");
// Print the final counts for each pattern
for (let i = 1; i <= n; i++) {
    const unique_id = pattern_end_node_ids[i];
    console.log(`Pattern "${my_input[i-1]}" count: ${ac.final_ans[unique_id]}`);
}
