fun main(args: Array<String>) {
    data class Node(val v: Int, var left: Node? = null, var right: Node? = null) {
        override fun toString() = " $v"

        fun preOrder()  { print(this); left?.preOrder(); right?.preOrder() }
        fun inorder()   { left?.inorder(); print(this); right?.inorder() }
        fun postOrder() { left?.postOrder(); right?.postOrder(); print(this) }

        fun levelOrder() = with(mutableListOf(this)) {
            do {
                val node = removeAt(0)
                print(node)
                node.left?.let { add(it) }
                node.right?.let { add(it) }
            } while (any())
        }

        inline fun exec(name: String, f: (Node) -> Unit) {
            print(name)
            f(this)
            println()
        }
    }

    val nodes = Array(10) { Node(it) }

    nodes[1].left = nodes[2]
    nodes[1].right = nodes[3]
    nodes[2].left = nodes[4]
    nodes[2].right = nodes[5]
    nodes[4].left = nodes[7]
    nodes[3].left = nodes[6]
    nodes[6].left = nodes[8]
    nodes[6].right = nodes[9]

    with(nodes[1]) {
        exec("   preOrder:", Node::preOrder)
        exec("    inorder:", Node::inorder)
        exec("  postOrder:", Node::postOrder)
        exec("level-order:", Node::levelOrder)
    }
}
