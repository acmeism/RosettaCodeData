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

fun <T: Number> insertAfter(prev: Node<T>, new: Node<T>) {
    new.next = prev.next
    prev.next = new
}

fun main(args: Array<String>) {
    val b = Node(3)
    val a = Node(1, b)
    println("Before insertion : $a")
    val c = Node(2)
    insertAfter(a, c)
    println("After  insertion : $a")
}
