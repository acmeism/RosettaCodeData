// version 1.1.2

class LinkedList<E> {
    class Node<E>(var data: E, var prev: Node<E>? = null, var next: Node<E>? = null) {
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

    var first: Node<E>? = null
    var last:  Node<E>? = null

    fun addFirst(value: E) {
        if (first == null) {
            first = Node(value)
            last =  first
        }
        else {
            val node = first!!
            first = Node(value, null, node)
            node.prev = first
        }
    }

    fun addLast(value: E) {
        if (last == null) {
            last = Node(value)
            first = last
        }
        else {
            val node = last!!
            last = Node(value, node, null)
            node.next = last
        }
    }

    fun insert(after: Node<E>?, value: E) {
        if (after == null)
            addFirst(value)
        else if (after == last)
            addLast(value)
        else {
            val next = after.next
            val new = Node(value, after, next)
            after.next = new
            if (next != null) next.prev = new
        }
    }

    override fun toString() = first.toString()

    fun firstToLast() = first?.toString() ?: ""

    fun lastToFirst(): String {
        if (last == null) return ""
        val sb = StringBuilder(last.toString())
        var node = last!!.prev
        while (node != null) {
             sb.append(" -> ", node.data.toString())
             node = node.prev
        }
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val ll = LinkedList<Int>()
    ll.addFirst(1)
    ll.addLast(4)
    ll.insert(ll.first, 2)
    ll.insert(ll.last!!.prev, 3)
    println("First to last : ${ll.firstToLast()}")
    println("Last to first : ${ll.lastToFirst()}")
}
