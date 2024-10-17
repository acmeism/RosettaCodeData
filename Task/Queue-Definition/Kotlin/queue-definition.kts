// version 1.1.2

import java.util.LinkedList

class Queue<E> {
    private val data = LinkedList<E>()

    val size get() = data.size

    val empty get() = size == 0

    fun push(element: E) = data.add(element)

    fun pop(): E {
        if (empty) throw RuntimeException("Can't pop elements from an empty queue")
        return data.removeFirst()
    }

   val top: E
        get() {
            if (empty) throw RuntimeException("Empty queue can't have a top element")
            return data.first()
        }

    fun clear() = data.clear()

    override fun toString() = data.toString()
}

fun main(args: Array<String>) {
    val q = Queue<Int>()
    (1..5).forEach { q.push(it) }
    println(q)
    println("Size of queue = ${q.size}")
    print("Popping: ")
    (1..3).forEach { print("${q.pop()} ") }
    println("\nRemaining in queue: $q")
    println("Top element is now ${q.top}")
    q.clear()
    println("After clearing, queue is ${if(q.empty) "empty" else "not empty"}")
    try {
        q.pop()
    }
    catch (e: Exception) {
        println(e.message)
    }
}
