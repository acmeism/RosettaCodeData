// Node class represents a node in the Red-Black Tree
data class Node(
    var value: Int = 0,
    var parent: Node? = null,
    var left: Node? = null,
    var right: Node? = null,
    var color: Int = 1 // 1 for Red, 0 for Black
) {
    // Constructor for null node
    constructor() : this(0, null, null, null, 0)
}

// RBTree class represents a Red-Black Tree
class RBTree {
    private val nullNode: Node = Node()
    private var root: Node = nullNode

    // Creates a new node with the given value
    private fun newNode(value: Int): Node {
        val node = Node(value)
        node.left = nullNode
        node.right = nullNode
        return node
    }

    // Inserts a new node with the given key
    fun insertNode(key: Int) {
        val node = newNode(key)
        node.parent = null
        node.left = nullNode
        node.right = nullNode
        node.color = 1 // Red

        var y: Node? = null
        var x: Node = root // Changed to non-nullable since we handle nullNode explicitly

        while (x != nullNode) {
            y = x
            x = if (node.value < x.value) x.left!! else x.right!!
        }

        node.parent = y
        when {
            y == null -> root = node
            node.value < y.value -> y.left = node
            else -> y.right = node
        }

        if (node.parent == null) {
            node.color = 0 // Black
            return
        }

        if (node.parent?.parent == null) {
            return
        }

        fixInsert(node)
    }

    // Finds the node with the minimum value in the subtree rooted at node
    private fun minimum(node: Node): Node {
        var current = node
        while (current.left != nullNode) {
            current = current.left!!
        }
        return current
    }

    // Performs a left rotation on the given node
    private fun leftRotate(x: Node) {
        val y = x.right!!
        x.right = y.left
        if (y.left != nullNode) {
            y.left!!.parent = x
        }

        y.parent = x.parent
        when {
            x.parent == null -> root = y
            x == x.parent!!.left -> x.parent!!.left = y
            else -> x.parent!!.right = y
        }
        y.left = x
        x.parent = y
    }

    // Performs a right rotation on the given node
    private fun rightRotate(x: Node) {
        val y = x.left!!
        x.left = y.right
        if (y.right != nullNode) {
            y.right!!.parent = x
        }

        y.parent = x.parent
        when {
            x.parent == null -> root = y
            x == x.parent!!.right -> x.parent!!.right = y
            else -> x.parent!!.left = y
        }
        y.right = x
        x.parent = y
    }

    // Fixes the Red-Black Tree after insertion
    private fun fixInsert(k: Node) {
        var node = k
        while (node.parent?.color == 1) {
            if (node.parent == node.parent!!.parent!!.right) {
                val u = node.parent!!.parent!!.left
                if (u?.color == 1) {
                    u.color = 0
                    node.parent!!.color = 0
                    node.parent!!.parent!!.color = 1
                    node = node.parent!!.parent!!
                } else {
                    if (node == node.parent!!.left) {
                        node = node.parent!!
                        rightRotate(node)
                    }
                    node.parent!!.color = 0
                    node.parent!!.parent!!.color = 1
                    leftRotate(node.parent!!.parent!!)
                }
            } else {
                val u = node.parent!!.parent!!.right
                if (u?.color == 1) {
                    u.color = 0
                    node.parent!!.color = 0
                    node.parent!!.parent!!.color = 1
                    node = node.parent!!.parent!!
                } else {
                    if (node == node.parent!!.right) {
                        node = node.parent!!
                        leftRotate(node)
                    }
                    node.parent!!.color = 0
                    node.parent!!.parent!!.color = 1
                    rightRotate(node.parent!!.parent!!)
                }
            }
            if (node == root) {
                break
            }
        }
        root.color = 0
    }

    // Fixes the Red-Black Tree after deletion
    private fun fixDelete(x: Node?) {
        var current = x
        while (current != root && current?.color == 0) {
            if (current == current.parent!!.left) {
                var s = current.parent!!.right!!
                if (s.color == 1) {
                    s.color = 0
                    current.parent!!.color = 1
                    leftRotate(current.parent!!)
                    s = current.parent!!.right!!
                }

                if (s.left!!.color == 0 && s.right!!.color == 0) {
                    s.color = 1
                    current = current.parent
                } else {
                    if (s.right!!.color == 0) {
                        s.left!!.color = 0
                        s.color = 1
                        rightRotate(s)
                        s = current.parent!!.right!!
                    }

                    s.color = current.parent!!.color
                    current.parent!!.color = 0
                    s.right!!.color = 0
                    leftRotate(current.parent!!)
                    current = root
                }
            } else {
                var s = current.parent!!.left!!
                if (s.color == 1) {
                    s.color = 0
                    current.parent!!.color = 1
                    rightRotate(current.parent!!)
                    s = current.parent!!.left!!
                }

                if (s.right!!.color == 0 && s.left!!.color == 0) {
                    s.color = 1
                    current = current.parent
                } else {
                    if (s.left!!.color == 0) {
                        s.right!!.color = 0
                        s.color = 1
                        leftRotate(s)
                        s = current.parent!!.left!!
                    }

                    s.color = current.parent!!.color
                    current.parent!!.color = 0
                    s.left!!.color = 0
                    rightRotate(current.parent!!)
                    current = root
                }
            }
        }
        current?.color = 0
    }

    // Replaces one subtree with another
    private fun rbTransplant(u: Node, v: Node) {
        when {
            u.parent == null -> root = v
            u == u.parent!!.left -> u.parent!!.left = v
            else -> u.parent!!.right = v
        }
        v.parent = u.parent
    }

    // Helper function for deleteNode
    private fun deleteNodeHelper(node: Node?, key: Int) {
        var z: Node = nullNode
        var temp: Node? = node

        while (temp != nullNode) {
            if (temp?.value == key) {
                z = temp
            }
            temp = if (temp?.value!! <= key) temp.right else temp.left
        }

        if (z == nullNode) {
            println("Value not present in Tree !!")
            return
        }

        var y: Node = z
        val yOriginalColor = y.color
        var x: Node

        when {
            z.left == nullNode -> {
                x = z.right!!
                rbTransplant(z, z.right!!)
            }
            z.right == nullNode -> {
                x = z.left!!
                rbTransplant(z, z.left!!)
            }
            else -> {
                y = minimum(z.right!!)
                val yOriginalColorInner = y.color
                x = y.right!!
                if (y.parent == z) {
                    x.parent = y
                } else {
                    rbTransplant(y, y.right!!)
                    y.right = z.right
                    y.right!!.parent = y
                }

                rbTransplant(z, y)
                y.left = z.left
                y.left!!.parent = y
                y.color = z.color
            }
        }

        if (yOriginalColor == 0) {
            fixDelete(x)
        }
    }

    // Deletes a node with the given value
    fun deleteNode(value: Int) {
        deleteNodeHelper(root, value)
    }

    // Recursively prints the tree
    private fun printCall(node: Node?, indent: String, last: Boolean) {
        if (node != nullNode) {
            print(indent)
            val newIndent = if (last) {
                print("R----")
                indent + "     "
            } else {
                print("L----")
                indent + "|    "
            }

            val sColor = if (node?.color == 1) "RED" else "BLACK"
            println("${node?.value}($sColor)")
            printCall(node?.left, newIndent, false)
            printCall(node?.right, newIndent, true)
        }
    }

    // Prints the entire tree
    fun printTree() {
        printCall(root, "", true)
    }
}


object MainKt{
  // Main function for testing
  @JvmStatic
  fun main(args: Array<String>) {
      val bst = RBTree()

      println("State of the tree after inserting the 30 keys:")
      for (x in 1 until 30) {
          bst.insertNode(x)
      }
      bst.printTree()

      println("\nState of the tree after deleting the 15 keys:")
      for (x in 1 until 15) {
          bst.deleteNode(x)
      }
      bst.printTree()
  }
}
