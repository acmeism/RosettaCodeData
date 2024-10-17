// version 1.1.51

val s = "std, ieee, des_system_lib, dw01, dw02, dw03, dw04, dw05, " +
        "dw06, dw07, dware, gtech, ramlib, std_cell_lib, synopsys"

val deps = mutableListOf(
     2 to 0, 2 to 14, 2 to 13, 2 to 4, 2 to 3, 2 to 12, 2 to 1,
     3 to 1, 3 to 10, 3 to 11,
     4 to 1, 4 to 10,
     5 to 0, 5 to 14, 5 to 10, 5 to 4, 5 to 3, 5 to 1, 5 to 11,
     6 to 1, 6 to 3, 6 to 10, 6 to 11,
     7 to 1, 7 to 10,
     8 to 1, 8 to 10,
     9 to 1, 9 to 10,
     10 to 1,
     11 to 1,
     12 to 0, 12 to 1,
     13 to 1
)

class Graph(s: String, edges: List<Pair<Int,Int>>) {

    val vertices = s.split(", ")
    val numVertices = vertices.size
    val adjacency = List(numVertices) { BooleanArray(numVertices) }

    init {
        for (edge in edges) adjacency[edge.first][edge.second] = true
    }

    fun hasDependency(r: Int, todo: List<Int>): Boolean {
        return todo.any { adjacency[r][it] }
    }

    fun topoSort(): List<String>? {
        val result = mutableListOf<String>()
        val todo = MutableList<Int>(numVertices) { it }
        try {
            outer@ while(!todo.isEmpty()) {
                for ((i, r) in todo.withIndex()) {
                    if (!hasDependency(r, todo)) {
                        todo.removeAt(i)
                        result.add(vertices[r])
                        continue@outer
                     }
                }
                throw Exception("Graph has cycles")
            }
        }
        catch (e: Exception) {
            println(e)
            return null
        }
        return result
    }
}

fun main(args: Array<String>) {
    val g = Graph(s, deps)
    println("Topologically sorted order:")
    println(g.topoSort())
    println()
    // now insert 3 to 6 at index 10 of deps
    deps.add(10, 3 to 6)
    val g2 = Graph(s, deps)
    println("Following the addition of dw04 to the dependencies of dw01:")
    println(g2.topoSort())
}
