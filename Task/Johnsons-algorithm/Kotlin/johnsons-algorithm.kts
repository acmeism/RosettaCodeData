import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashMap

object MainKt {
    private val INF = Double.MAX_VALUE

    data class Edge(val u: Int, val v: Int, val weight: Double)
    data class VertexAndWeight(val vertex: Int, val weight: Double)

    @JvmStatic
    fun main(args: Array<String>) {
        // The element (i, j) is the weight of the edge from vertex i to vertex j.
        // INF, for infinity, means that there is no edge from vertex i to vertex j.
        val graph = listOf(
            listOf(0.0, -5.0, 2.0, 3.0),
            listOf(INF, 0.0, 4.0, INF),
            listOf(INF, INF, 0.0, 1.0),
            listOf(INF, INF, INF, 0.0)
        )

        val result = johnsonsAlgorithm(graph)

        if (result.isPresent) {
            println("All pairs shortest paths:")
            println("The element (i, j) is the shortest path between vertex i and vertex j.")
            result.get().forEach { row ->
                print("[")
                row.forEach { number ->
                    print(if (number == INF) "INF " else "$number ")
                }
                println("]")
            }
        } else {
            println("A negative cycle was detected in the graph.")
        }
    }

    private fun johnsonsAlgorithm(graph: List<List<Double>>): Optional<List<List<Double>>> {
        val vertexCount = graph.size
        val originalEdges = ArrayList<Edge>()

        // Step 0: Build a list of edges for the original graph
        for (i in 0 until vertexCount) {
            for (j in 0 until vertexCount) {
                val weight = graph[i][j]
                if (i == j) {
                    if (weight != 0.0) {
                        println("Warning: graph[i][i] for i = $i is $weight, expected to be 0.0, resetting it to 0.0")
                    }
                } else if (weight != INF) {
                    originalEdges.add(Edge(i, j, weight))
                }
            }
        }

        // Step 1: Form the augmented graph
        val augmentedEdges = originalEdges + (0 until vertexCount).map { Edge(vertexCount, it, 0.0) }

        // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
        val hValues = bellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount)

        if (hValues.isEmpty) {
            return Optional.empty() // A negative cycle was detected by the Bellman-Ford Algorithm
        }

        val values = hValues.get().toMutableList()
        values.removeAt(values.size - 1) // Remove the value for the augmented vertex

        // Step 3: Reweight the edges
        val reweightedAdjacencies = HashMap<Int, MutableList<VertexAndWeight>>()
        for (v in 0 until vertexCount) {
            reweightedAdjacencies[v] = ArrayList()
        }

        originalEdges.forEach { edge ->
            if (values[edge.u] == INF || values[edge.v] == INF) {
                println("Warning: invalid hValues detected by the Bellman-Ford Algorithm.")
            }
            val reweight = edge.weight + values[edge.u] - values[edge.v]
            reweightedAdjacencies[edge.u]?.add(VertexAndWeight(edge.v, reweight))
        }

        // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
        val allPairsShortestPaths = (0 until vertexCount).map { u ->
            dijkstraAlgorithm(vertexCount, reweightedAdjacencies, u, values)
        }

        // Step 5: Return the result matrix
        return Optional.of(allPairsShortestPaths)
    }

    private fun bellmanFordAlgorithm(
        augmentedVertexCount: Int,
        edges: List<Edge>,
        sourceVertex: Int
    ): Optional<List<Double>> {
        val distances = MutableList(augmentedVertexCount) { INF }
        distances[sourceVertex] = 0.0

        // Relax the edges (augmentedVertexCount - 1) times
        var updated: Boolean
        for (i in 0 until augmentedVertexCount - 1) {
            updated = false
            for (edge in edges) {
                if (distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v]) {
                    distances[edge.v] = distances[edge.u] + edge.weight
                    updated = true
                }
            }
            if (!updated) break
        }

        // Check for negative cycles in the graph
        for (edge in edges) {
            if (distances[edge.u] != INF && distances[edge.u] + edge.weight < distances[edge.v]) {
                return Optional.empty() // Indicates to the calling method that a negative cycle has been detected
            }
        }
        return Optional.of(distances)
    }

    private fun dijkstraAlgorithm(
        vertexCount: Int,
        reweightedAdjacencies: Map<Int, List<VertexAndWeight>>,
        sourceVertex: Int,
        values: List<Double>
    ): List<Double> {
        val distances = MutableList(vertexCount) { INF }
        distances[sourceVertex] = 0.0

        val priorityQueue = PriorityQueue<VertexAndWeight>(compareBy { it.weight })
        priorityQueue.add(VertexAndWeight(sourceVertex, 0.0))

        val finalDistances = MutableList(vertexCount) { INF }

        while (priorityQueue.isNotEmpty()) {
            val vertexAndWeight = priorityQueue.remove()
            val vertex = vertexAndWeight.vertex
            if (vertexAndWeight.weight > distances[vertex]) {
                continue
            }

            // Store the final shortest path distance, translated back to the distance in the original graph
            if (finalDistances[vertex] == INF) {
                if (distances[vertex] == INF) {
                    finalDistances[vertex] = INF
                } else {
                    finalDistances[vertex] = distances[vertex] - values[sourceVertex] + values[vertex]
                }
            }

            // Relax the edges outgoing from vertex
            reweightedAdjacencies[vertex]?.forEach { pair ->
                if (distances[vertex] != INF && distances[vertex] + pair.weight < distances[pair.vertex]) {
                    distances[pair.vertex] = distances[vertex] + pair.weight
                    priorityQueue.add(VertexAndWeight(pair.vertex, distances[pair.vertex]))
                }
            }
        }

        // Translate distance back to its original weight for any remaining reachable vertices
        for (i in 0 until vertexCount) {
            if (finalDistances[i] == INF && distances[i] != INF) {
                finalDistances[i] = distances[i] - values[sourceVertex] + values[i]
            }
        }
        return finalDistances
    }
}

