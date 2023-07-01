// version 1.1.2

class Node<T: Number>(var data: T, var next: Node<T>? = null) {
    override fun toString(): String {
        val sb = StringBuilder(this.data.toString())
        var node = this.next
        while (node != null) {
            sb.append(" -> ", node.data.toString())
            node = node.next
        }
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val n = Node(1, Node(2, Node(3)))
    println(n)
}
