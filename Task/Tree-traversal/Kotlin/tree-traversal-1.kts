data class Node(val v: Int, var left: Node? = null, var right: Node? = null) {
    override fun toString() = "$v"
}

fun preOrder(n: Node?) {
    n?.let {
        print("$n ")
        preOrder(n.left)
        preOrder(n.right)
    }
}

fun inorder(n: Node?) {
    n?.let {
        inorder(n.left)
        print("$n ")
        inorder(n.right)
    }
}

fun postOrder(n: Node?) {
    n?.let {
        postOrder(n.left)
        postOrder(n.right)
        print("$n ")
    }
}

fun levelOrder(n: Node?) {
    n?.let {
        val queue = mutableListOf(n)
        while (queue.isNotEmpty()) {
            val node = queue.removeAt(0)
            print("$node ")
            node.left?.let { queue.add(it) }
            node.right?.let { queue.add(it) }
        }
    }
}

inline fun exec(name: String, n: Node?, f: (Node?) -> Unit) {
    print(name)
    f(n)
    println()
}

fun main(args: Array<String>) {
    val nodes = Array(10) { Node(it) }

    nodes[1].left = nodes[2]
    nodes[1].right = nodes[3]

    nodes[2].left = nodes[4]
    nodes[2].right = nodes[5]

    nodes[4].left = nodes[7]

    nodes[3].left = nodes[6]

    nodes[6].left = nodes[8]
    nodes[6].right = nodes[9]

    exec("   preOrder: ", nodes[1], ::preOrder)
    exec("    inorder: ", nodes[1], ::inorder)
    exec("  postOrder: ", nodes[1], ::postOrder)
    exec("level-order: ", nodes[1], ::levelOrder)
}
