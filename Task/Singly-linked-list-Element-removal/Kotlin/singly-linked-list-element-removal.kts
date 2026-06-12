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

fun <T: Number> remove(first: Node<T>, removal: Node<T>) {
    if (first === removal)
        first.next = null
    else {
        var node: Node<T>? = first
        while (node != null) {
            if (node.next === removal) {
                val next = removal.next
                removal.next = null
                node.next = next
                return
            }
            node = node.next
        }
    }
}

fun main(args: Array<String>) {
    val b = Node(3)
    val a = Node(1, b)
    println("Before insertion  : $a")
    val c = Node(2)
    insertAfter(a, c)
    println("After  insertion  : $a")
    remove(a, c) // remove node we've just inserted
    println("After 1st removal : $a")
    remove(a, b) // remove last node
    println("After 2nd removal : $a")
}
