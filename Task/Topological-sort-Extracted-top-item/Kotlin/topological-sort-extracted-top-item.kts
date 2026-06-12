// version 1.1.51

import java.util.LinkedList

val s = "top1, top2, ip1, ip2, ip3, ip1a, ip2a, ip2b, ip2c, ipcommon, des1, " +
        "des1a, des1b, des1c, des1a1, des1a2, des1c1, extra1"

val deps = mutableListOf(
    0 to 10, 0 to 2, 0 to 3,
    1 to 10, 1 to 3, 1 to 4,
    2 to 17, 2 to 5, 2 to 9,
    3 to 6, 3 to 7, 3 to 8, 3 to 9,
    10 to 11, 10 to 12, 10 to 13,
    11 to 14, 11 to 15,
    13 to 16, 13 to 17
)

val files = listOf("top1", "top2", "ip1")

class Graph(s: String, edges: List<Pair<Int, Int>>) {

    val vertices = s.split(", ")
    val numVertices = vertices.size
    val adjacency = List(numVertices) { BooleanArray(numVertices) }

    init {
        for (edge in edges) adjacency[edge.first][edge.second] = true
    }

    fun topLevels(): List<String> {
        val result = mutableListOf<String>()
        // look for empty columns
        outer@ for (c in 0 until numVertices) {
            for (r in 0 until numVertices) {
                if (adjacency[r][c]) continue@outer
            }
            result.add(vertices[c])
        }
        return result
    }

    fun compileOrder(item: String): List<String> {
        val result = LinkedList<String>()
        val queue  = LinkedList<Int>()
        queue.add(vertices.indexOf(item))
        while (!queue.isEmpty()) {
            val r = queue.poll()
            for (c in 0 until numVertices) {
                if (adjacency[r][c] && !queue.contains(c)) queue.add(c)
            }
            result.addFirst(vertices[r])
        }
        return result.distinct().toList()
    }
}

fun main(args: Array<String>) {
    val g = Graph(s, deps)
    println("Top levels:  ${g.topLevels()}")
    for (f in files) println("\nCompile order for $f: ${g.compileOrder(f)}")
}
