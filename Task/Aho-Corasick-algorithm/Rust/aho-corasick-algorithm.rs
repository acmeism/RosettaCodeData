use std::collections::VecDeque;
use std::io;

// Define the Node struct, similar to the Python class
#[derive(Clone, Default, Debug)] // Derive Default for easy initialization, Clone for vec! macro
struct Node {
    son: [usize; 26], // Child node indices (0 means no child)
    ans: usize,       // Counter for matches ending/passing through here
    fail: usize,      // Failure link node index
    du: isize,        // In-degree in the failure graph (for topological sort)
    idx: usize,       // Unique ID if this node marks the end of a pattern (0 otherwise)
}

// Define the ACAutomaton struct
struct ACAutomaton {
    tr: Vec<Node>,    // Vector storing all nodes
    tot: usize,       // Total number of nodes created (next available index)
    final_ans: Vec<usize>, // Stores final counts for each pattern ID
    pidx: usize,      // Counter for assigning unique pattern IDs
}

impl ACAutomaton {
    // Constructor
    fn new(max_nodes: usize) -> Self {
        ACAutomaton {
            // Initialize with max_nodes + 1 capacity (index 0 is the root)
            // Using vec![Node::default(); max_nodes] pre-allocates and default-initializes
            tr: vec![Node::default(); max_nodes],
            tot: 0, // Root node is at index 0, next node will be 1
            final_ans: Vec::new(),
            pidx: 0, // Pattern IDs start from 1
        }
    }

    // Resets the automaton (optional, similar to Python's init)
    // Note: In Rust, often you'd just create a new instance instead of resetting.
    /*
    fn init(&mut self, max_nodes: usize) {
        self.tr = vec![Node::default(); max_nodes];
        self.tot = 0;
        self.pidx = 0;
        self.final_ans.clear();
    }
    */

    // Inserts a pattern into the Trie
    fn insert(&mut self, pattern: &str) -> usize {
        let mut u = 0; // Start at the root node (index 0)
        for char in pattern.chars() {
            // Ensure character is a lowercase letter
            if !('a'..='z').contains(&char) {
                // Handle invalid characters if necessary, here we panic
                 panic!("Invalid character in pattern: {}", char);
            }
            let char_code = (char as u8 - b'a') as usize;

            // If child node doesn't exist, create it
            if self.tr[u].son[char_code] == 0 {
                self.tot += 1;
                 // Check if we exceed allocated size
                if self.tot >= self.tr.len() {
                    // In a real scenario, you might resize self.tr or return an error
                    panic!("Exceeded maximum number of nodes");
                }
                self.tr[u].son[char_code] = self.tot;
            }
            // Move to the child node
            u = self.tr[u].son[char_code];
        }

        // If this node hasn't been marked as an end node yet, assign a new ID
        if self.tr[u].idx == 0 {
            self.pidx += 1;
            self.tr[u].idx = self.pidx;
        }
        // Return the unique ID for the pattern ending at this node
        self.tr[u].idx
    }

    // Builds the failure links using BFS
    fn build(&mut self) {
        let mut q = VecDeque::new();

        // Initialize queue with direct children of the root
        for i in 0..26 {
            if self.tr[0].son[i] != 0 {
                q.push_back(self.tr[0].son[i]);
                // Failure link for root's children is the root itself (index 0)
                // Their in-degree (du) remains 0 as root doesn't contribute
            }
        }

        while let Some(u) = q.pop_front() {
            for i in 0..26 {
                let son_node_idx = self.tr[u].son[i];
                // Use a temporary variable to avoid borrowing issues
                let fail_node_idx_for_u = self.tr[u].fail;

                if son_node_idx != 0 {
                    // Find failure link for the child: follow parent's fail link
                    // and see if it has a child for the same character `i`.
                    self.tr[son_node_idx].fail = self.tr[fail_node_idx_for_u].son[i];

                    // Increment the in-degree (du) of the node pointed to by the failure link
                    // This is needed for the final answer calculation (topological sort)
                    let target_fail_node_idx = self.tr[son_node_idx].fail;
                    self.tr[target_fail_node_idx].du += 1;

                    // Add the child node to the queue for processing
                    q.push_back(son_node_idx);
                } else {
                    // If child doesn't exist for character `i`, make the current node's
                    // `son[i]` point to the same node that its failure node points to for `i`.
                    // This optimizes the query process by pre-calculating transitions.
                    self.tr[u].son[i] = self.tr[fail_node_idx_for_u].son[i];
                }
            }
        }
    }

    // Queries the automaton with the given text
    fn query(&mut self, text: &str) {
        let mut u = 0; // Start at the root
        for char in text.chars() {
             // Ensure character is a lowercase letter
            if !('a'..='z').contains(&char) {
                 // Handle invalid characters if necessary, here we skip
                 // Or you could panic: panic!("Invalid character in text: {}", char);
                 continue;
            }
            let char_code = (char as u8 - b'a') as usize;

            // Transition to the next state using the trie links
            // (which also incorporate failure links thanks to build())
            u = self.tr[u].son[char_code];

            // Increment the answer count for the current node
            // This node represents the longest suffix of the text processed so far
            // that is also a prefix in the dictionary.
            self.tr[u].ans += 1;
            // Note: The final propagation of counts happens in calculate_final_answers
        }
    }

    // Calculates final answers by propagating counts up the failure links
    // using a topological sort based on the failure graph.
    fn calculate_final_answers(&mut self) {
        // Initialize final_ans vector (size is based on the number of unique patterns)
        // +1 because pattern IDs (pidx) are 1-based.
        self.final_ans = vec![0; self.pidx + 1];
        let mut q = VecDeque::new();

        // Initialize queue with nodes having in-degree 0 in the failure graph
        // These are the nodes that are not pointed to by any failure link (or only by root's children initially)
        // Iterate from 0 to self.tot (inclusive) as node indices go up to self.tot
        for i in 0..=self.tot {
            if self.tr[i].du == 0 {
                q.push_back(i);
            }
        }

        // Process nodes in topological order
        while let Some(u) = q.pop_front() {
            let node_idx = self.tr[u].idx;
            let current_ans = self.tr[u].ans; // Store ans before modifying fail node

            // If this node corresponds to the end of a pattern, record its count
            if node_idx != 0 {
                 if node_idx > self.pidx {
                     // Should not happen if logic is correct
                    panic!("Invalid node_idx encountered: {}", node_idx);
                 }
                self.final_ans[node_idx] = current_ans;
            }

            // Propagate the count of this node to its failure node
            let v = self.tr[u].fail;
            self.tr[v].ans += current_ans; // Add counts from u to its failure node v

            // Decrease the in-degree of the failure node
            self.tr[v].du -= 1;

            // If the failure node's in-degree becomes 0, add it to the queue
            if self.tr[v].du == 0 {
                q.push_back(v);
            }
        }
    }

     // Helper function to get the final answer for a specific pattern ID
    fn get_ans(&self, pattern_id: usize) -> usize {
        if pattern_id > 0 && pattern_id < self.final_ans.len() {
            self.final_ans[pattern_id]
        } else {
            // Handle invalid ID, return 0 or panic/error
            0
        }
    }
}


fn main() -> io::Result<()> {
    // Constants similar to Python
    const MAX_NODES: usize = 200000 + 6;
    // MAX_N is implicitly handled by vector size if reading from input

    // Create the automaton
    let mut ac = ACAutomaton::new(MAX_NODES);

    // --- Example Usage (Matching Python Code) ---
    let n = 5;
    let mut pattern_end_node_ids = vec![0; n + 1]; // Use vec! macro for initialization
    let my_input = ["a", "bb", "aa", "abaa", "abaaa"]; // Removed "abaaabaa" as it was the text
    let text = "abaaabaa";

    println!("Inserting patterns:");
    for i in 0..n {
        let pattern = my_input[i];
        println!("  - \"{}\"", pattern);
        // Store the unique ID returned by insert. Note the index shift (i+1).
        pattern_end_node_ids[i + 1] = ac.insert(pattern);
    }
    println!("Total nodes after insert: {}", ac.tot);
    println!("Pattern IDs assigned: {:?}", &pattern_end_node_ids[1..=n]);


    println!("\nBuilding failure links...");
    ac.build();
    println!("Build complete.");

    println!("\nQuerying text: \"{}\"", text);
    ac.query(text);
    println!("Query complete.");

    println!("\nCalculating final answers...");
    ac.calculate_final_answers();
    println!("Calculation complete.");

    println!("\nResults:");
    for i in 1..=n {
        let unique_id = pattern_end_node_ids[i];
        let count = ac.get_ans(unique_id); // Use helper or direct access
        // let count = ac.final_ans[unique_id]; // Direct access also works if calculate_final_answers was called
        println!("Pattern \"{}\" (ID {}): {}", my_input[i-1], unique_id, count);
    }
    println!();

    Ok(())
}
