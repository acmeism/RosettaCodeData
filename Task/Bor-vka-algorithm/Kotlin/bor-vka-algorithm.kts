data class Edge(val u: Int, val v: Int, val weight: Double)

class Graph(private val vertexCount: Int) {
    private val edges = mutableListOf<Edge>()

    fun addEdge(edge: Edge) {
        edges.add(edge)
    }

    fun boruvkaMinimumSpanningTree() {
        val parent = MutableList(vertexCount) { it }
        val rank = MutableList(vertexCount) { 0 }
        val cheapest = MutableList(vertexCount) { Edge(-1, -1, -1.0) }

        var treeCount = vertexCount
        var minimumSpanningTreeWeight = 0.0

        while (treeCount > 1) {
            // Traverse all edges and update cheapest edge for every tree
            edges.forEach { edge ->
                val u = edge.u
                val v = edge.v
                val weight = edge.weight

                val index1 = find(parent, u)
                val index2 = find(parent, v)

                if (index1 != index2) {
                    if (cheapest[index1].weight == -1.0 || cheapest[index1].weight > weight) {
                        cheapest[index1] = Edge(u, v, weight)
                    }
                    if (cheapest[index2].weight == -1.0 || cheapest[index2].weight > weight) {
                        cheapest[index2] = Edge(u, v, weight)
                    }
                }
            }

            // Add the cheapest edges to the minimum spanning tree
            for (vertex in 0 until vertexCount) {
                if (cheapest[vertex].weight != -1.0) {
                    val u = cheapest[vertex].u
                    val v = cheapest[vertex].v
                    val weight = cheapest[vertex].weight

                    val index1 = find(parent, u)
                    val index2 = find(parent, v)

                    if (index1 != index2) {
                        minimumSpanningTreeWeight += weight
                        unionSet(parent, rank, index1, index2)
                        println("Edge $u--$v with weight $weight is included in the minimum spanning tree")
                        treeCount--
                    }
                }
            }
        }

        println("\nWeight of minimum spanning tree is $minimumSpanningTreeWeight")
    }

    private fun find(parent: MutableList<Int>, vertex: Int): Int {
        if (parent[vertex] != vertex) {
            parent[vertex] = find(parent, parent[vertex])
        }
        return parent[vertex]
    }

    private fun unionSet(parent: MutableList<Int>, rank: MutableList<Int>, u: Int, v: Int) {
        val uRoot = find(parent, u)
        val vRoot = find(parent, v)

        when {
            rank[uRoot] < rank[vRoot] -> parent[uRoot] = vRoot
            rank[uRoot] > rank[vRoot] -> parent[vRoot] = uRoot
            else -> {
                parent[vRoot] = uRoot
                rank[uRoot]++
            }
        }
    }
}

fun main() {
    val graph = Graph(4)
    graph.addEdge(Edge(0, 1, 10.0))
    graph.addEdge(Edge(0, 2, 6.0))
    graph.addEdge(Edge(0, 3, 5.0))
    graph.addEdge(Edge(1, 3, 15.0))
    graph.addEdge(Edge(2, 3, 4.0))
    graph.boruvkaMinimumSpanningTree()
}

