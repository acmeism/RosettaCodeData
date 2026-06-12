import "./dynamic" for Struct
import "./queue" for Queue

/* Node class representing a node in the Trie/Automaton:

   son:  Children nodes for 'a' through 'z'. Stores index in the main 'tr' list.
   ans:  Count of times this node is visited during query (intermediate count).
   fail: Index of the failure link node in the 'tr' list.
   du:   In-degree for the topological sort based on failure links.
   idx:  Unique ID assigned if this node marks the end of a pattern (0 otherwise).
*/
var Node_t = Struct.create("Node", ["son", "ans", "fail", "du", "idx"])

class Node is Node_t {
    construct new() {
        super(List.filled(26, 0), 0, 0, 0, 0)
    }
}

/* ACAutomaton class implementing the Aho-Corasick algorithm. */
class ACAutomaton {
    construct new(maxNodes) {
        init_(maxNodes)
    }

    // Private method to initialize fields.
    init_(maxNodes) {
        // tr: List storing all Node objects. tr[0] is the root.
        _tr = List.filled(maxNodes, null)
        for (i in 0...maxNodes) _tr[i] = Node.new() // pre-allocate nodes

        // tot: Total number of nodes created (index for the next new node).
        _tot = 0 // root is node 0, next node will be 1

        // finalAns: List to store final counts for each pattern (indexed by pattern ID).
        _finalAns = []

        // pidx: Counter for assigning unique IDs to patterns.
        _pidx = 0
    }

    // Optional: Method to reset the automaton (if reusing the same instance)
    reset() {
        init_(_tr.count)
    }

    // Inserts a pattern into the Trie structure.
    insert(pattern) {
        var u = 0  // start at the root node
        for (cp in pattern.codePoints) {
            // Ensure cp represents a lowercase letter ASCII letter.
            if (cp < 97 || cp > 122) {
                 Fiber.abort("Invalid character \"%(String.fromCodePoint(cp))\" in pattern.")
            }

            var charCode = cp - 97  // subtract code for 'a'
            // If child node for this character doesn't exist, create it.
            if (_tr[u].son[charCode] == 0) {
                _tot = _tot + 1  // increment total node count
                // Link parent to new child node index.
                // Note: Node object for _tr[_tot] was already created in constructor.
                _tr[u].son[charCode] = _tot
            }
            // Move to the child node.
            u = _tr[u].son[charCode]
        }

        // Mark the end node of the pattern with a unique ID if it doesn't have one.
        if (_tr[u].idx == 0) {
            _pidx = _pidx + 1   // increment pattern ID counter
            _tr[u].idx = _pidx  // assign the ID
        }
        // Return the unique ID associated with this pattern.
        return _tr[u].idx
    }

    // Property getter for 'finalAns'.
    finalAns { _finalAns }

    // Builds the failure links using BFS.
    build() {
        var q = Queue.new()

        // Initialize queue with children of the root.
        for (i in 0..25) {
            if (_tr[0].son[i] != 0) {
                q.push(_tr[0].son[i])
                // Optional: Nodes directly under root have root (0)
                // as fail link (already default).
                // _tr[_tr[0].son[i]].fail = 0
            }
        }

        while (!q.isEmpty) {
            var u = q.pop()  // dequeue node index

            // Iterate through all possible characters ('a' to 'z').
            for (i in 0..25) {
                var sonNodeIdx = _tr[u].son[i]
                var failNodeIdx = _tr[u].fail
                if (sonNodeIdx != 0) {
                    // If a direct child exists:
                    // Its failure link is the node reached by following the parent's
                    // failure link and then taking the same character transition.
                    _tr[sonNodeIdx].fail = _tr[failNodeIdx].son[i]

                    // Increment the in-degree of the node pointed to by the fail link
                    // (for the final calculation step).
                    _tr[_tr[sonNodeIdx].fail].du = _tr[_tr[sonNodeIdx].fail].du + 1

                    // Enqueue the child node.
                    q.push(sonNodeIdx)
                } else {
                    // If a direct child doesn't exist (son is 0):
                    // Create a "virtual" transition by pointing this character's slot
                    // to the node reached by following the parent's failure link
                    // and taking the same character transition. This optimizes the query phase.
                    _tr[u].son[i] = _tr[failNodeIdx].son[i]
                }
            }
        }
    }

    // Queries the text against the built automaton.
    query(text) {
        var u = 0  // start at the root
        for (cp in text.codePoints) {
            // Ensure cp represents a lowercase letter ASCII letter.
            if (cp < 97 || cp > 122) {
                 Fiber.abort("Invalid character \"%(String.fromCodePoint(cp))\" in text.")
            }

            var charCode = cp - 97  // subtract the code for 'a'

            // Follow the transitions (or failure links implicitly via build step).
            u = _tr[u].son[charCode]

            // Increment the count for the current node.
            _tr[u].ans = _tr[u].ans + 1
        }
    }

    // Calculates the final counts for each pattern using failure links.
    calculateFinalAnswers() {
        // Initialize final answer array based on the number of unique patterns found.
        _finalAns = List.filled(_pidx + 1, 0)
        var q = Queue.new()  // queue for topological sort

        // Find all nodes with an in-degree of 0 (start points for the sort)
        // Iterate from 0 (root) up to the last created node index.
        for (i in 0.._tot) {
            if (_tr[i].du == 0) q.push(i)
        }

        // Perform topological sort on the reversed failure link graph.
        while (!q.isEmpty) {
            var u = q.pop()  // dequeue node index

            // If this node represents the end of a pattern, store its accumulated count.
            var nodeIdx = _tr[u].idx
            if (nodeIdx != 0) _finalAns[nodeIdx] = _tr[u].ans

            // Propagate the count to the node pointed to by the failure link.
            var v = _tr[u].fail
            if (v) { // Check if fail link exists (root's fail is 0)
                _tr[v].ans = _tr[v].ans + _tr[u].ans

                // Decrease the in-degree of the fail link node.
                _tr[v].du = _tr[v].du - 1

                // If the fail link node's in-degree becomes 0, enqueue it.
                if (_tr[v].du == 0) q.push(v)
            }
        }
    }
}

var MAX_NODES = 200000 + 6
var ac = ACAutomaton.new(MAX_NODES)
var n = 5
var patternEndNodeIds = List.filled(n + 1, 0) // using 1-based indexing

// Input data (hardcoded as per the example)
var myInput = ["a", "bb", "aa", "abaa", "abaaa"]
var text = "abaaabaa"

System.print("Inserting patterns...")
// Insert patterns and store their unique IDs
for (i in 1..n) {
    var pattern = myInput[i - 1]  // adjust index for 0-based myInput
    patternEndNodeIds[i] = ac.insert(pattern)
    // System.print("Inserted \"%(pattern)\", assigned ID: %(patternEndNodeIds[i])")
}

System.print("Building failure links...")
ac.build()

System.print("Querying text...")
ac.query(text)

System.print("Calculating final answers...")
ac.calculateFinalAnswers()

System.print("\nResults:")
// Print the final counts for each pattern.
for (i in 1..n) {
    var uniqueId = patternEndNodeIds[i]
    System.print("Pattern \"%(myInput[i-1])\" count: %(ac.finalAns[uniqueId])")
}
