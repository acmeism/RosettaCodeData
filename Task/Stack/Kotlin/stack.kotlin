// version 1.1.2

class Stack<E> {
    private val data = mutableListOf<E>()

    val size get() = data.size

    val empty get() = size == 0

    fun push(element: E) = data.add(element)

    fun pop(): E {
        if (empty) throw RuntimeException("Can't pop elements from an empty stack")
        return data.removeAt(data.lastIndex)
    }

    val top: E
        get() {
            if (empty) throw RuntimeException("Empty stack can't have a top element")
            return data.last()
        }

    fun clear() = data.clear()

    override fun toString() = data.toString()
}

fun main(args: Array<String>) {
    val s = Stack<Int>()
    (1..5).forEach { s.push(it) }
    println(s)
    println("Size of stack = ${s.size}")
    print("Popping: ")
    (1..3).forEach { print("${s.pop()} ") }
    println("\nRemaining on stack: $s")
    println("Top element is now ${s.top}")
    s.clear()
    println("After clearing, stack is ${if(s.empty) "empty" else "not empty"}")
    try {
        s.pop()
    }
    catch (e: Exception) {
        println(e.message)
    }
}
