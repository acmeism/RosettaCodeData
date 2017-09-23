// version 1.1.2

import java.util.*

fun main(args: Array<String>) {
    val q: Queue<Int> = ArrayDeque<Int>()
    (1..5).forEach { q.add(it) }
    println(q)
    println("Size of queue = ${q.size}")
    print("Removing: ")
    (1..3).forEach { print("${q.remove()} ") }
    println("\nRemaining in queue: $q")
    println("Head element is now ${q.element()}")
    q.clear()
    println("After clearing, queue is ${if(q.isEmpty()) "empty" else "not empty"}")
    try {
        q.remove()
    }
    catch (e: NoSuchElementException) {
        println("Can't remove elements from an empty queue")
    }
}
