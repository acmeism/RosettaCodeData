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

fun <T: Number> insert(after: Node<T>, new: Node<T>) {
    new.next = after.next
    if (after.next != null) after.next!!.prev = new
    new.prev = after
    after.next = new
}

fun main(args: Array<String>) {
    val a = Node(1)
    val b = Node(3, a)
    a.next = b
    println("Before insertion : $a")
    val c = Node(2)
    insert(after = a, new = c)
    println("After  insertion : $a")
}
