// version 1.1.2

class Node<T: Number>(var data: T, var prev: Node<T>? = null, var next: Node<T>? = null) {
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
    val n1 = Node(1)
    val n2 = Node(2, n1)
    n1.next = n2
    val n3 = Node(3, n2)
    n2.next = n3
    println(n1)
    println(n2)
    println(n3)
}
