import Foundation

// MARK: - AVL Tree ---------------------------------------------------------

final class AVLTree {
    // ---------- Node ------------------------------------------------------
    private class Node {
        var key: Int
        var balance: Int = 0
        var height: Int = 0

        var left: Node?
        var right: Node?
        weak var parent: Node?          // weak to avoid retain cycles

        init(key: Int, parent: Node?) {
            self.key = key
            self.parent = parent
        }
    }

    // ---------- Root -------------------------------------------------------
    private var root: Node?

    // ---------- Public API -------------------------------------------------

    /// Inserts `key`. Returns `true` if the key was added, `false` if it already existed.
    @discardableResult
    func insert(_ key: Int) -> Bool {
        // empty tree → new root
        guard let rootNode = root else {
            root = Node(key: key, parent: nil)
            return true
        }

        var n: Node? = rootNode
        while let cur = n {
            if cur.key == key { return false }          // duplicate

            let goLeft = key < cur.key
            let parent = cur
            n = goLeft ? cur.left : cur.right

            // we have found the empty spot → insert
            if n == nil {
                let newNode = Node(key: key, parent: parent)
                if goLeft {
                    parent.left = newNode
                } else {
                    parent.right = newNode
                }
                rebalance(parent)                       // fix AVL balance upwards
                break
            }
        }
        return true
    }

    /// Deletes `key` if it exists. Does nothing when the key is not present.
    func delete(_ key: Int) {
        var current = root
        while let node = current {
            if key == node.key {
                delete(node)                // internal helper that really removes the node
                return
            }
            current = (key < node.key) ? node.left : node.right
        }
        // key not found → nothing to do
    }

    /// Prints the balance factor of every node in‑order.
    func printBalance() {
        printBalance(node: root)
    }

    // ---------- Private helpers -------------------------------------------

    /// Removes `node` from the tree (used by the public `delete(_:)` above).
    private func delete(_ node: Node) {
        // ----- 1️⃣ leaf node ------------------------------------------------
        if node.left == nil && node.right == nil {
            if let parent = node.parent {
                if parent.left === node { parent.left = nil }
                else { parent.right = nil }
                rebalance(parent)
            } else {
                root = nil                     // tree becomes empty
            }
            return
        }

        // ----- 2️⃣ node has a left subtree → replace with predecessor -----
        if let left = node.left {
            var predecessor = left
            while let r = predecessor.right { predecessor = r }
            node.key = predecessor.key
            delete(predecessor)
        }
        // ----- 3️⃣ otherwise it has a right subtree → replace with successor
        else if let right = node.right {
            var successor = right
            while let l = successor.left { successor = l }
            node.key = successor.key
            delete(successor)
        }
    }

    /// Walks upward from `n`, fixing heights, balances and performing rotations.
    private func rebalance(_ n: Node) {
        setBalance(of: n)

        var node = n
        if node.balance == -2 {
            // left heavy
            if height(of: node.left?.left) >= height(of: node.left?.right) {
                node = rotateRight(node)
            } else {
                node = rotateLeftThenRight(node)
            }
        } else if node.balance == 2 {
            // right heavy
            if height(of: node.right?.right) >= height(of: node.right?.left) {
                node = rotateLeft(node)
            } else {
                node = rotateRightThenLeft(node)
            }
        }

        // continue upwards – or make this node the new root
        if let parent = node.parent {
            rebalance(parent)
        } else {
            root = node
        }
    }

    // ---------- Rotations -------------------------------------------------

    private func rotateLeft(_ a: Node) -> Node {
        guard let b = a.right else { return a }      // safety guard

        // detach b from a
        b.parent = a.parent
        a.right = b.left
        a.right?.parent = a

        // attach a under b
        b.left = a
        a.parent = b

        // reconnect b with the rest of the tree
        if let p = b.parent {
            if p.left === a {
                p.left = b
            } else {
                p.right = b
            }
        }

        setBalance(of: a, b)
        return b
    }

    private func rotateRight(_ a: Node) -> Node {
        guard let b = a.left else { return a }       // safety guard

        b.parent = a.parent
        a.left = b.right
        a.left?.parent = a

        b.right = a
        a.parent = b

        if let p = b.parent {
            if p.left === a {
                p.left = b
            } else {
                p.right = b
            }
        }

        setBalance(of: a, b)
        return b
    }

    private func rotateLeftThenRight(_ n: Node) -> Node {
        if let left = n.left {
            n.left = rotateLeft(left)
        }
        return rotateRight(n)
    }

    private func rotateRightThenLeft(_ n: Node) -> Node {
        if let right = n.right {
            n.right = rotateRight(right)
        }
        return rotateLeft(n)
    }

    // ---------- Height / Balance helpers ----------------------------------

    /// Height of a node – `-1` for `nil` (matches the Java implementation).
    private func height(of node: Node?) -> Int {
        node?.height ?? -1
    }

    /// Re‑computes stored height of `node`.
    private func reheight(_ node: Node?) {
        guard let node = node else { return }
        node.height = 1 + max(height(of: node.left), height(of: node.right))
    }

    /// Updates both `height` and `balance` for every supplied node.
    private func setBalance(of nodes: Node...) {
        for n in nodes {
            reheight(n)
            n.balance = height(of: n.right) - height(of: n.left)
        }
    }

    // ---------- Printing ---------------------------------------------------

    private func printBalance(node: Node?) {
        guard let node = node else { return }
        printBalance(node: node.left)
        print("\(node.balance) ", terminator: "")
        printBalance(node: node.right)
    }
}

// MARK: - Demo -------------------------------------------------------------

let tree = AVLTree()

print("Inserting values 1 to 10")
for i in 1...10 {
    _ = tree.insert(i)
}

print("Printing balance: ", terminator: "")
tree.printBalance()
print()   // newline
