import java.util.*

data class Edge(val from: Int, val to: Int)

class BipartiteGraph(private val m: Int, private val n: Int) {

    private var adjacencyLists: List<MutableList<Int>> = List(m + 1) { mutableListOf<Int>() }
    private var pairU: MutableList<Int> = MutableList(m + 1) { NIL }
    private var pairV: MutableList<Int> = MutableList(n + 1) { NIL }
    private var levels: MutableList<Int> = MutableList(m + 1) { INFINITY }

    fun addEdge(u: Int, v: Int) {
        require(u in 1..m && v in 1..n) { "Attempt to add an edge ($u, $v) which is out of bounds" }
        adjacencyLists[u].add(v)
    }

    fun hopcroftKarpAlgorithm(): Int {
        pairU = MutableList(m + 1) { NIL }
        pairV = MutableList(n + 1) { NIL }

        var matchingSize = 0

        while (breadthFirstSearch()) {
            for (u in 1..m) {
                if (pairU[u] == NIL && depthFirstSearch(u)) {
                    matchingSize++
                }
            }
        }
        return matchingSize
    }

    private fun breadthFirstSearch(): Boolean {
        val queue: Queue<Int> = ArrayDeque()

        for (u in 1..m) {
            if (pairU[u] == NIL) {
                levels[u] = 0
                queue.offer(u)
            } else {
                levels[u] = INFINITY
            }
        }

        levels[NIL] = INFINITY

        while (queue.isNotEmpty()) {
            val u = queue.poll()
            if (levels[u] < levels[NIL]) {
                for (v in adjacencyLists[u]) {
                    val matchedU = pairV[v]
                    if (levels[matchedU] == INFINITY) {
                        levels[matchedU] = levels[u] + 1
                        queue.offer(matchedU)
                    }
                }
            }
        }

        return levels[NIL] != INFINITY
    }

    private fun depthFirstSearch(u: Int): Boolean {
        if (u != NIL) {
            for (v in adjacencyLists[u]) {
                val matchedU = pairV[v]
                if (levels[matchedU] == levels[u] + 1) {
                    if (depthFirstSearch(matchedU)) {
                        pairV[v] = u
                        pairU[u] = v
                        return true
                    }
                }
            }
            levels[u] = INFINITY
            return false
        }
        return true
    }

    companion object {
        private const val NIL = 0
        private const val INFINITY = Int.MAX_VALUE
    }
}

fun testValue(testNumber: Int, m: Int, n: Int, edges: List<Edge>, expectedResult: Int): Int {
    val graph = BipartiteGraph(m, n)
    edges.forEach { edge -> graph.addEdge(edge.from, edge.to) }
    val result = graph.hopcroftKarpAlgorithm()
    println("Test $testNumber: Result = $result, Expected = $expectedResult")
    if (result == expectedResult) return 1
    println("Test $testNumber failed.")
    return 0
}

fun main() {
    println("Running tests:")
    var successCount = 0

    // Test Case 1
    successCount += testValue(1, 3, 5, listOf(Edge(1, 4)), 1)

    // Test Case 2
    successCount += testValue(2, 6, 6, listOf(Edge(1, 4), Edge(1, 5), Edge(5, 1)), 2)

    // Test Case 3: Complete Bipartite Graph K(3,3)
    val edges3 = mutableListOf<Edge>()
    for (i in 1..3) {
        for (j in 1..3) {
            edges3.add(Edge(i, j))
        }
    }
    successCount += testValue(3, 3, 3, edges3, 3)

    // Test Case 4: No edges
    successCount += testValue(4, 2, 2, emptyList(), 0)

    // Test Case 5
    val edges5 = listOf(
        Edge(1, 1), Edge(1, 3), Edge(2, 3),
        Edge(3, 4), Edge(4, 3), Edge(4, 2)
    )
    successCount += testValue(5, 4, 4, edges5, 4)

    if (successCount == 5) {
        println("All tests passed.")
    }
}
