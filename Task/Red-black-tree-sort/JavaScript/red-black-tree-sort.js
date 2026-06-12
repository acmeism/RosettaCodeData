// Define Color Constants
const RED = 1;
const BLACK = 0;

// Define Node Class
class Node {
    constructor(val) {
        this.val = val;           // Value of Node
        this.parent = null;       // Parent of Node
        this.left = null;         // Left Child of Node
        this.right = null;        // Right Child of Node
        this.color = RED;         // 1 for Red, 0 for Black (new nodes are RED)
    }
}

// Define R-B Tree Class
class RBTree {
    constructor() {
        // Create the sentinel NULL_NODE
        // It's important that all leaf nodes point to this single instance.
        this.NULL_NODE = new Node(0); // Value doesn't matter much
        this.NULL_NODE.color = BLACK;
        this.NULL_NODE.left = null;   // Or could point to itself, but null is fine for JS checks
        this.NULL_NODE.right = null;
        this.NULL_NODE.parent = null; // Sentinel's parent is null
        this.root = this.NULL_NODE;   // Tree initially empty
    }

    // Insert New Node
    insertNode(key) {
        const node = new Node(key);
        node.parent = null;
        // node.val = key; // Already set by constructor
        node.left = this.NULL_NODE;
        node.right = this.NULL_NODE;
        node.color = RED; // New nodes start as Red

        let y = null;
        let x = this.root;

        // Traverse the tree to find the correct insertion point
        while (x !== this.NULL_NODE) {
            y = x;
            if (node.val < x.val) {
                x = x.left;
            } else {
                x = x.right;
            }
        }

        // y is parent of x
        node.parent = y;
        if (y === null) {
            // Tree was empty
            this.root = node;
        } else if (node.val < y.val) {
            y.left = node;
        } else {
            y.right = node;
        }

        // If the new node is the root, color it black and return
        if (node.parent === null) {
            node.color = BLACK;
            return;
        }

        // If the grandparent is null, just return (parent is root, already black)
        if (node.parent.parent === null) {
            return;
        }

        // Fix the Red-Black Tree properties after insertion
        this.fixInsert(node);
    }

    // Find the node with the minimum value in the subtree rooted at node
    minimum(node) {
        while (node.left !== this.NULL_NODE) {
            node = node.left;
        }
        return node;
    }

    // Left Rotate
    LR(x) {
        const y = x.right; // Set y
        x.right = y.left; // Turn y's left subtree into x's right subtree
        if (y.left !== this.NULL_NODE) {
            y.left.parent = x;
        }

        y.parent = x.parent; // Link y's parent to x's parent
        if (x.parent === null) {
            this.root = y; // y becomes root
        } else if (x === x.parent.left) {
            x.parent.left = y;
        } else {
            x.parent.right = y;
        }

        y.left = x; // Put x on y's left
        x.parent = y;
    }

    // Right Rotate
    RR(x) {
        const y = x.left; // Set y
        x.left = y.right; // Turn y's right subtree into x's left subtree
        if (y.right !== this.NULL_NODE) {
            y.right.parent = x;
        }

        y.parent = x.parent; // Link y's parent to x's parent
        if (x.parent === null) {
            this.root = y; // y becomes root
        } else if (x === x.parent.right) {
            x.parent.right = y;
        } else {
            x.parent.left = y;
        }

        y.right = x; // Put x on y's right
        x.parent = y;
    }

    // Fix Violations After Insertion
    fixInsert(k) {
        // Continue fixing until k's parent is BLACK or k is root
        while (k.parent.color === RED) {
            // If k's parent is the right child of its parent (grandparent)
            if (k.parent === k.parent.parent.right) {
                const u = k.parent.parent.left; // Uncle node
                // Case 1: Uncle is RED
                if (u.color === RED) {
                    u.color = BLACK;
                    k.parent.color = BLACK;
                    k.parent.parent.color = RED;
                    k = k.parent.parent; // Move k up to grandparent
                } else {
                    // Case 2: Uncle is BLACK and k is a left child (Triangle)
                    if (k === k.parent.left) {
                        k = k.parent;
                        this.RR(k); // Right rotate on parent
                    }
                    // Case 3: Uncle is BLACK and k is a right child (Line)
                    k.parent.color = BLACK;
                    k.parent.parent.color = RED;
                    this.LR(k.parent.parent); // Left rotate on grandparent
                }
            } else { // If k's parent is the left child of its parent (grandparent)
                const u = k.parent.parent.right; // Uncle node
                // Case 1: Uncle is RED
                if (u.color === RED) {
                    u.color = BLACK;
                    k.parent.color = BLACK;
                    k.parent.parent.color = RED;
                    k = k.parent.parent; // Move k up to grandparent
                } else {
                    // Case 2: Uncle is BLACK and k is a right child (Triangle)
                    if (k === k.parent.right) {
                        k = k.parent;
                        this.LR(k); // Left rotate on parent
                    }
                    // Case 3: Uncle is BLACK and k is a left child (Line)
                    k.parent.color = BLACK;
                    k.parent.parent.color = RED;
                    this.RR(k.parent.parent); // Right rotate on grandparent
                }
            }
            // Stop if k becomes root
            if (k === this.root) {
                break;
            }
        }
        // Ensure root is always BLACK
        this.root.color = BLACK;
    }

    // Fix Violations After Deletion
    fixDelete(x) {
        // Continue fixing until x is root or x is RED
        while (x !== this.root && x.color === BLACK) {
            // If x is the left child
            if (x === x.parent.left) {
                let s = x.parent.right; // Sibling node
                // Case 1: Sibling s is RED
                if (s.color === RED) {
                    s.color = BLACK;
                    x.parent.color = RED;
                    this.LR(x.parent); // Left rotate on parent
                    s = x.parent.right; // Update sibling
                }

                // Case 2: Sibling s is BLACK, and both of s's children are BLACK
                if (s.left.color === BLACK && s.right.color === BLACK) {
                    s.color = RED;
                    x = x.parent; // Move x up
                } else {
                    // Case 3: Sibling s is BLACK, s.left is RED, s.right is BLACK
                    if (s.right.color === BLACK) {
                        s.left.color = BLACK;
                        s.color = RED;
                        this.RR(s); // Right rotate on sibling
                        s = x.parent.right; // Update sibling
                    }

                    // Case 4: Sibling s is BLACK, s.right is RED
                    s.color = x.parent.color;
                    x.parent.color = BLACK;
                    s.right.color = BLACK;
                    this.LR(x.parent); // Left rotate on parent
                    x = this.root; // Fixing is done, exit loop
                }
            } else { // If x is the right child
                let s = x.parent.left; // Sibling node
                // Case 1: Sibling s is RED
                if (s.color === RED) {
                    s.color = BLACK;
                    x.parent.color = RED;
                    this.RR(x.parent); // Right rotate on parent
                    s = x.parent.left; // Update sibling
                }

                // Case 2: Sibling s is BLACK, and both of s's children are BLACK
                // Note C++ code had `s->right->color == 0 && s->left->color == 0` which seems correct
                if (s.right.color === BLACK && s.left.color === BLACK) {
                    s.color = RED;
                    x = x.parent; // Move x up
                } else {
                     // Case 3: Sibling s is BLACK, s.right is RED, s.left is BLACK
                    if (s.left.color === BLACK) {
                        s.right.color = BLACK;
                        s.color = RED;
                        this.LR(s); // Left rotate on sibling
                        s = x.parent.left; // Update sibling
                    }

                    // Case 4: Sibling s is BLACK, s.left is RED
                    s.color = x.parent.color;
                    x.parent.color = BLACK;
                    s.left.color = BLACK;
                    this.RR(x.parent); // Right rotate on parent
                    x = this.root; // Fixing is done, exit loop
                }
            }
        }
        // Ensure the final node x (which might be root or a RED node) is BLACK
        x.color = BLACK;
    }

    // Transplant node u with node v
    rbTransplant(u, v) {
        if (u.parent === null) {
            // u was root
            this.root = v;
        } else if (u === u.parent.left) {
            // u was left child
            u.parent.left = v;
        } else {
            // u was right child
            u.parent.right = v;
        }
        // Update v's parent, even if v is NULL_NODE (parent might become null)
        v.parent = u.parent;
    }

    // Helper function for deletion
    deleteNodeHelper(node, key) {
        // Find the node to delete (z)
        let z = this.NULL_NODE;
        let temp = node; // Start searching from the given node (usually root)

        while (temp !== this.NULL_NODE) {
            if (temp.val === key) {
                z = temp;
                break; // Found the node
            }

            if (temp.val <= key) { // Note: original C++ searches right even if equal, implies duplicates possible on right
                temp = temp.right;
            } else {
                temp = temp.left;
            }
        }

        // Node with the key not found
        if (z === this.NULL_NODE) {
            console.log(`Value ${key} not present in Tree !!`);
            return;
        }

        let y = z; // y is the node either removed or moved
        let y_original_color = y.color;
        let x; // x is the node that moves into y's original position

        // Case 1 & 2: z has one or zero children
        if (z.left === this.NULL_NODE) {
            x = z.right;
            this.rbTransplant(z, z.right);
        } else if (z.right === this.NULL_NODE) {
            x = z.left;
            this.rbTransplant(z, z.left);
        } else {
            // Case 3: z has two children
            y = this.minimum(z.right); // Find successor (smallest in right subtree)
            y_original_color = y.color;
            x = y.right; // x is successor's right child

            if (y.parent === z) {
                // If successor y is direct child of z
                // We need x's parent to point correctly if x isn't NULL_NODE
                // This check handles the case where x is NULL_NODE slightly differently
                // than the C++ code, but achieves the same goal:
                // If x becomes y's child, its parent must be y.
                 if (x !== this.NULL_NODE) x.parent = y;
            } else {
                // Successor y is deeper in the right subtree
                this.rbTransplant(y, y.right); // Replace y with its right child
                y.right = z.right;             // Link y to z's original right subtree
                y.right.parent = y;            // Update parent pointer of that subtree's root
            }

            // Replace z with y
            this.rbTransplant(z, y);
            y.left = z.left;            // Link y to z's original left subtree
            y.left.parent = y;          // Update parent pointer
            y.color = z.color;          // Give y z's original color
        }

        // If the original color of the node that was moved/removed (y) was BLACK,
        // the tree might violate RB properties. Fix it starting from x.
        if (y_original_color === BLACK) {
            this.fixDelete(x);
        }
        // No explicit 'delete z' needed due to garbage collection
    }

    // Public deletion function
    deleteNode(val) {
        this.deleteNodeHelper(this.root, val);
    }

    // Helper function for printing the tree (recursive)
    printCall(node, indent, isLast) {
        if (node !== this.NULL_NODE) {
            process.stdout.write(indent); // Use process.stdout.write to avoid newline
            if (isLast) {
                process.stdout.write("R----");
                indent += "     ";
            } else {
                process.stdout.write("L----");
                indent += "|    ";
            }

            const s_color = (node.color === RED) ? "RED" : "BLACK";
            console.log(`${node.val}(${s_color})`); // console.log adds newline

            // Recurse: left child first, then right child
            // Pass copies of indent or modify/restore it
            this.printCall(node.left, indent, false);
            this.printCall(node.right, indent, true);
        }
    }

    // Function to start the printing process
    printTree() {
        if (this.root === this.NULL_NODE) {
             console.log("Tree is empty.");
             return;
        }
        this.printCall(this.root, "", true);
    }
}

// --- Main execution part (equivalent to C++ main) ---
const bst = new RBTree();

console.log("State of the tree after inserting the 30 keys:");
for (let x = 1; x < 30; ++x) {
    bst.insertNode(x);
}
bst.printTree();

console.log("\nState of the tree after deleting the first 15 keys:");
for (let x = 1; x < 15; ++x) {
    bst.deleteNode(x);
}
bst.printTree();
