// version 1.1.3

/* the list index is the first vertex in the edge(s) */
val g = listOf(
    intArrayOf(1),        // 0
    intArrayOf(2),        // 1
    intArrayOf(0),        // 2
    intArrayOf(1, 2, 4),  // 3
    intArrayOf(3, 5),     // 4
    intArrayOf(2, 6),     // 5
    intArrayOf(5),        // 6
    intArrayOf(4, 6, 7)   // 7
)

fun kosaraju(g: List<IntArray>): List<List<Int>> {
    // 1. For each vertex u of the graph, mark u as unvisited. Let l be empty.
    val size = g.size
    val vis = BooleanArray(size)                 // all false by default
    val l = IntArray(size)                       // all zero by default
    var x = size                                 // index for filling l in reverse order
    val t = List(size) { mutableListOf<Int>() }  // transpose graph

    // Recursive subroutine 'visit':
    fun visit(u: Int) {
        if (!vis[u]) {
            vis[u] = true
            for (v in g[u]) {
                visit(v)
                t[v].add(u)  // construct transpose
            }
            l[--x] = u
        }
     }

    // 2. For each vertex u of the graph do visit(u)
    for (u in g.indices) visit(u)
    val c = IntArray(size)  // used for component assignment

    // Recursive subroutine 'assign':
    fun assign(u: Int, root: Int) {
        if (vis[u]) {  // repurpose vis to mean 'unassigned'
            vis[u] = false
            c[u] = root
            for (v in t[u]) assign(v, root)
        }
    }

    // 3: For each element u of l in order, do assign(u, u)
    for (u in l) assign(u, u)

    // Obtain list of SCC's from 'c' and return it
    return c.withIndex()
            .groupBy { it.value }.values
            .map { ivl -> ivl.map { it.index } }
}

fun main(args: Array<String>) {
    println(kosaraju(g).joinToString("\n"))
}
