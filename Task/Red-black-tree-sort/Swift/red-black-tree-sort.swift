// Node class represents a node in the Red-Black Tree
class Node {
    var val: Int
    var parent: Node?
    var left: Node?
    var right: Node?
    var color: Int // 1 for Red, 0 for Black

    init(_ val: Int) {
        self.val = val
        self.parent = nil
        self.left = nil
        self.right = nil
        self.color = 1 // Red
    }

    // Constructor for null node
    init() {
        self.val = 0
        self.color = 0 // Black
        self.left = nil
        self.right = nil
        self.parent = nil
    }
}

// RBTree class represents a Red-Black Tree
class RBTree {
    private var nullNode: Node
    private var root: Node

    // Constructor creates a new Red-Black Tree
    init() {
        self.nullNode = Node() // Creates null node with default values
        self.root = self.nullNode
    }

    // Creates a new node with the given value
    private func newNode(_ val: Int) -> Node {
        let node = Node(val)
        node.left = self.nullNode
        node.right = self.nullNode
        return node
    }

    // Inserts a new node with the given key
    func insertNode(_ key: Int) {
        let node = newNode(key)
        node.parent = nil
        node.left = self.nullNode
        node.right = self.nullNode
        node.color = 1 // Red

        var y: Node? = nil
        var x = self.root

        while x !== self.nullNode {
            y = x
            if node.val < x.val {
                x = x.left!
            } else {
                x = x.right!
            }
        }

        node.parent = y
        if y == nil {
            self.root = node
        } else if node.val < y!.val {
            y!.left = node
        } else {
            y!.right = node
        }

        if node.parent == nil {
            node.color = 0 // Black
            return
        }

        if node.parent!.parent == nil {
            return
        }

        fixInsert(node)
    }

    // Finds the node with the minimum value in the subtree rooted at node
    private func minimum(_ node: Node) -> Node {
        var current = node
        while current.left !== self.nullNode {
            current = current.left!
        }
        return current
    }

    // Performs a left rotation on the given node
    private func leftRotate(_ x: Node) {
        let y = x.right!
        x.right = y.left
        if y.left !== self.nullNode {
            y.left!.parent = x
        }

        y.parent = x.parent
        if x.parent == nil {
            self.root = y
        } else if x === x.parent!.left {
            x.parent!.left = y
        } else {
            x.parent!.right = y
        }
        y.left = x
        x.parent = y
    }

    // Performs a right rotation on the given node
    private func rightRotate(_ x: Node) {
        let y = x.left!
        x.left = y.right
        if y.right !== self.nullNode {
            y.right!.parent = x
        }

        y.parent = x.parent
        if x.parent == nil {
            self.root = y
        } else if x === x.parent!.right {
            x.parent!.right = y
        } else {
            x.parent!.left = y
        }
        y.right = x
        x.parent = y
    }

    // Fixes the Red-Black Tree after insertion
    private func fixInsert(_ k: Node) {
        var current = k
        while current.parent!.color == 1 {
            if current.parent === current.parent!.parent!.right {
                let u = current.parent!.parent!.left!
                if u.color == 1 {
                    u.color = 0
                    current.parent!.color = 0
                    current.parent!.parent!.color = 1
                    current = current.parent!.parent!
                } else {
                    if current === current.parent!.left {
                        current = current.parent!
                        rightRotate(current)
                    }
                    current.parent!.color = 0
                    current.parent!.parent!.color = 1
                    leftRotate(current.parent!.parent!)
                }
            } else {
                let u = current.parent!.parent!.right!
                if u.color == 1 {
                    u.color = 0
                    current.parent!.color = 0
                    current.parent!.parent!.color = 1
                    current = current.parent!.parent!
                } else {
                    if current === current.parent!.right {
                        current = current.parent!
                        leftRotate(current)
                    }
                    current.parent!.color = 0
                    current.parent!.parent!.color = 1
                    rightRotate(current.parent!.parent!)
                }
            }
            if current === self.root {
                break
            }
        }
        self.root.color = 0
    }

    // Fixes the Red-Black Tree after deletion
    private func fixDelete(_ x: Node) {
        var current = x
        while current !== self.root && current.color == 0 {
            if current === current.parent!.left {
                var s = current.parent!.right!
                if s.color == 1 {
                    s.color = 0
                    current.parent!.color = 1
                    leftRotate(current.parent!)
                    s = current.parent!.right!
                }

                if s.left!.color == 0 && s.right!.color == 0 {
                    s.color = 1
                    current = current.parent!
                } else {
                    if s.right!.color == 0 {
                        s.left!.color = 0
                        s.color = 1
                        rightRotate(s)
                        s = current.parent!.right!
                    }

                    s.color = current.parent!.color
                    current.parent!.color = 0
                    s.right!.color = 0
                    leftRotate(current.parent!)
                    current = self.root
                }
            } else {
                var s = current.parent!.left!
                if s.color == 1 {
                    s.color = 0
                    current.parent!.color = 1
                    rightRotate(current.parent!)
                    s = current.parent!.left!
                }

                if s.right!.color == 0 && s.left!.color == 0 {
                    s.color = 1
                    current = current.parent!
                } else {
                    if s.left!.color == 0 {
                        s.right!.color = 0
                        s.color = 1
                        leftRotate(s)
                        s = current.parent!.left!
                    }

                    s.color = current.parent!.color
                    current.parent!.color = 0
                    s.left!.color = 0
                    rightRotate(current.parent!)
                    current = self.root
                }
            }
        }
        current.color = 0
    }

    // Replaces one subtree with another
    private func rbTransplant(_ u: Node, _ v: Node) {
        if u.parent == nil {
            self.root = v
        } else if u === u.parent!.left {
            u.parent!.left = v
        } else {
            u.parent!.right = v
        }
        v.parent = u.parent
    }

    // Helper function for deleteNode
    private func deleteNodeHelper(_ node: Node, _ key: Int) {
        var z = self.nullNode
        var temp = node

        while temp !== self.nullNode {
            if temp.val == key {
                z = temp
            }

            if temp.val <= key {
                temp = temp.right!
            } else {
                temp = temp.left!
            }
        }

        if z === self.nullNode {
            print("Value not present in Tree !!")
            return
        }

        var y = z
        let yOriginalColor = y.color
        var x: Node

        if z.left === self.nullNode {
            x = z.right!
            rbTransplant(z, z.right!)
        } else if z.right === self.nullNode {
            x = z.left!
            rbTransplant(z, z.left!)
        } else {
            y = minimum(z.right!)
            let yOriginalColor = y.color
            x = y.right!
            if y.parent === z {
                x.parent = y
            } else {
                rbTransplant(y, y.right!)
                y.right = z.right
                y.right!.parent = y
            }

            rbTransplant(z, y)
            y.left = z.left
            y.left!.parent = y
            y.color = z.color
        }

        if yOriginalColor == 0 {
            fixDelete(x)
        }
    }

    // Deletes a node with the given value
    func deleteNode(_ val: Int) {
        deleteNodeHelper(self.root, val)
    }

    // Recursively prints the tree
    private func printCall(_ node: Node, _ indent: String, _ last: Bool) {
        if node !== self.nullNode {
            print(indent, terminator: "")
            var newIndent = indent
            if last {
                print("R----", terminator: "")
                newIndent += "     "
            } else {
                print("L----", terminator: "")
                newIndent += "|    "
            }

            let sColor = (node.color == 1) ? "RED" : "BLACK"
            print("\(node.val)(\(sColor))")
            printCall(node.left!, newIndent, false)
            printCall(node.right!, newIndent, true)
        }
    }

    // Prints the entire tree
    func printTree() {
        printCall(self.root, "", true)
    }
}

// Example usage
let bst = RBTree()

print("State of the tree after inserting the 30 keys:")
for x in 1..<30 {
    bst.insertNode(x)
}
bst.printTree()

print("\nState of the tree after deleting the 15 keys:")
for x in 1..<15 {
    bst.deleteNode(x)
}
bst.printTree()
