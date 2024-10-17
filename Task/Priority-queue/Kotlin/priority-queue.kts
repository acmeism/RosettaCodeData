import java.util.PriorityQueue

internal data class Task(val priority: Int, val name: String) : Comparable<Task> {
    override fun compareTo(other: Task) = when {
        priority < other.priority -> -1
        priority > other.priority -> 1
        else -> 0
    }
}

private infix fun String.priority(priority: Int) = Task(priority, this)

fun main(args: Array<String>) {
    val q = PriorityQueue(listOf("Clear drains" priority 3,
                                 "Feed cat" priority 4,
                                 "Make tea" priority 5,
                                 "Solve RC tasks" priority 1,
                                 "Tax return" priority 2))
    while (q.any()) println(q.remove())
}
