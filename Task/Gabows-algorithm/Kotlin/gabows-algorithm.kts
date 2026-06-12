import java.util.*

// Data class for edges
data class Edge(val from: Int, val to: Int)

/**
 * Representation of a directed graph, or digraph, using adjacency lists.
 * Vertices are identified by integers starting from zero.
 */
class Digraph(private val vertexCount: Int) {
    private var edgeCount = 0
    private val adjacencyLists: List<MutableList<Int>>

    init {
        require(vertexCount >= 0) { "Number of vertices must be non-negative" }
        adjacencyLists = List(vertexCount) { mutableListOf<Int>() }
    }

    fun addEdge(from: Int, to: Int) {
        validateVertex(from)
        validateVertex(to)
        adjacencyLists[from].add(to)
        edgeCount++
    }

    fun vertexCount(): Int = vertexCount

    fun edgeCount(): Int = edgeCount

    fun adjacencyList(vertex: Int): List<Int> {
        validateVertex(vertex)
        return adjacencyLists[vertex]
    }

    override fun toString(): String {
        val result = StringBuilder("Digraph has $vertexCount vertices and $edgeCount edges\nAdjacency lists:\n")
        for (vertex in 0 until vertexCount) {
            result.append(
                "${if (vertex < 10) " " else ""}$vertex: ${
                    adjacencyLists[vertex].sorted().joinToString(" ")
                }\n"
            )
        }
        return result.toString()
    }

    private fun validateVertex(vertex: Int) {
        require(vertex in 0 until vertexCount) { "Vertex must be between 0 and ${vertexCount - 1}: $vertex" }
    }
}

/**
 * Determination of the strongly connected components (SCC's) of a directed graph using Gabow's algorithm.
 */
class GabowSCC(digraph: Digraph) {
    private val visited: MutableList<Boolean>
    private val componentIDs: MutableList<Int>
    private val preorders: MutableList<Int>
    private var preorderCount = 0
    private var sccCount = 0
    private val visitedVerticesStack = Stack<Int>()
    private val auxiliaryStack = Stack<Int>()

    companion object {
        private const val NONE = -1
    }

    init {
        visited = MutableList(digraph.vertexCount()) { false }
        componentIDs = MutableList(digraph.vertexCount()) { NONE }
        preorders = MutableList(digraph.vertexCount()) { NONE }

        for (vertex in 0 until digraph.vertexCount()) {
            if (!visited[vertex]) {
                depthFirstSearch(digraph, vertex)
            }
        }
    }

    // Return, for each vertex, a list of its strongly connected vertices
    fun components(): List<List<Int>> {
        val components = List(sccCount) { mutableListOf<Int>() }
        for (vertex in visited.indices) {
            val componentID = componentID(vertex)
            if (componentID != NONE) {
                components[componentID].add(vertex)
            } else {
                throw AssertionError("Warning: Vertex $vertex has no SCC ID assigned.")
            }
        }
        return components
    }

    // Return whether or not vertices 'v' and 'w' are in the same strongly connected component.
    fun isStronglyConnected(v: Int, w: Int): Boolean {
        validateVertex(v)
        validateVertex(w)
        // If either vertex was not visited, for example, due to it being in an unconnected graph component,
        // its id will be 'NONE', and they cannot be strongly connected unless
        // the graph is empty or has isolated vertices which is handled by the return condition below.
        return componentIDs[v] != NONE && componentIDs[v] == componentIDs[w]
    }

    // Return the component ID of the strong component containing 'vertex'.
    fun componentID(vertex: Int): Int {
        validateVertex(vertex)
        return componentIDs[vertex]
    }

    fun stronglyConnectedComponentCount(): Int = sccCount

    private fun depthFirstSearch(digraph: Digraph, vertex: Int) {
        visited[vertex] = true
        preorders[vertex] = preorderCount++
        visitedVerticesStack.push(vertex)
        auxiliaryStack.push(vertex)

        digraph.adjacencyList(vertex).forEach { w ->
            if (!visited[w]) {
                depthFirstSearch(digraph, w)
                // If 'w' is visited, but not yet assigned to a SCC,
                // then 'w' is on the current depth first path,
                // or in a SCC which has already been processed in this depth first path,
                // and this will be handled by the 'auxiliaryStack'.
            } else if (componentIDs[w] == NONE) {
                // Pop vertices from the 'auxiliaryStack' until the top vertex has a preorder <= preorder of 'w'.
                // This maintains the invariant that 'auxiliaryStack' contains a path of potential SCC roots.
                while (auxiliaryStack.isNotEmpty() && preorders[auxiliaryStack.peek()] > preorders[w]) {
                    auxiliaryStack.pop()
                }
            }
        }

        // 'vertex' is the root of a SCC,
        // if it remains on top of the 'auxiliaryStack' after exploring all of its descendants and back-edges.
        if (auxiliaryStack.isNotEmpty() && auxiliaryStack.peek() == vertex) {
            auxiliaryStack.pop()
            // Pop vertices from the 'auxiliaryStack' until 'vertex' is popped,
            // and assign these vertices the current strongly connected component id.
            while (visitedVerticesStack.isNotEmpty()) {
                val w = visitedVerticesStack.pop()
                componentIDs[w] = sccCount
                if (w == vertex) break
            }
            sccCount++
        }
    }

    private fun validateVertex(vertex: Int) {
        require(vertex in 0 until visited.size) { "Vertex $vertex is not between 0 and ${visited.size - 1}" }
    }
}

fun main() {
    val edges = listOf(
        Edge(4, 2), Edge(2, 3), Edge(3, 2), Edge(6, 0), Edge(0, 1),
        Edge(2, 0), Edge(11, 12), Edge(12, 9), Edge(9, 10), Edge(9, 11), Edge(8, 9),
        Edge(10, 12), Edge(0, 5), Edge(5, 4), Edge(3, 5), Edge(6, 4), Edge(6, 9),
        Edge(7, 6), Edge(7, 8), Edge(8, 7), Edge(5, 3), Edge(0, 6)
    )

    val digraph = Digraph(13)

    edges.forEach { edge -> digraph.addEdge(edge.from, edge.to) }
    println("Constructed digraph:")
    println(digraph)

    val gabowSCC = GabowSCC(digraph)
    println("It has ${gabowSCC.stronglyConnectedComponentCount()} strongly connected components.")

    val components = gabowSCC.components()
    println("\nComponents:")
    components.forEachIndexed { i, component ->
        println("Component $i: ${component.joinToString(" ")}")
    }

    // Example usage of the isStronglyConnected() and componentID() methods
    println("\nExample connectivity checks:")
    println("Vertices 0 and 3 strongly connected? ${gabowSCC.isStronglyConnected(0, 3)}")
    println("Vertices 0 and 7 strongly connected? ${gabowSCC.isStronglyConnected(0, 7)}")
    println("Vertices 9 and 12 strongly connected? ${gabowSCC.isStronglyConnected(9, 12)}")
    println("Component ID of vertex 5: ${gabowSCC.componentID(5)}")
    println("Component ID of vertex 8: ${gabowSCC.componentID(8)}")
}
