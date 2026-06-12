import java.util.*

object MainKt {
    private val cliques: MutableList<List<String>> = mutableListOf()

    @JvmStatic
    fun main(args: Array<String>) {
        val edges = listOf(
            Edge("a", "b"), Edge("b", "a"), Edge("a", "c"), Edge("c", "a"),
            Edge("b", "c"), Edge("c", "b"), Edge("d", "e"), Edge("e", "d"),
            Edge("d", "f"), Edge("f", "d"), Edge("e", "f"), Edge("f", "e")
        )

        // Build the graph as an adjacency list
        val graph: MutableMap<String, MutableSet<String>> = mutableMapOf()
        edges.forEach { edge ->
            graph.computeIfAbsent(edge.start) { mutableSetOf() }.add(edge.end)
        }

        // Initialize current clique, candidates, and processed vertices
        val currentClique: MutableSet<String> = mutableSetOf()
        val candidates: MutableSet<String> = mutableSetOf<String>().apply { addAll(graph.keys) }
        val processedVertices: MutableSet<String> = mutableSetOf()

        // Execute the Bron-Kerbosch algorithm to collect the cliques
        bronKerbosch(currentClique, candidates, processedVertices, graph)

        // Sort the cliques for consistent display
        cliques.sortWith(listComparator)

        // Display the cliques
        println(cliques)
    }

    private fun bronKerbosch(
        currentClique: MutableSet<String>,
        candidates: MutableSet<String>,
        processedVertices: MutableSet<String>,
        graph: Map<String, Set<String>>
    ) {
        if (candidates.isEmpty() && processedVertices.isEmpty()) {
            if (currentClique.size > 2) {
                val clique = ArrayList(currentClique)
                cliques.add(clique)
            }
            return
        }

        // Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
        val union = candidates.toMutableSet().apply { addAll(processedVertices) }
        val pivot = union.maxBy { s -> graph[s]?.size ?: 0 }

        if (pivot == null) {
            return
        }

        // 'possibles' are vertices in 'candidates' that are not neighbors of the 'pivot'
        val possibles = candidates.toMutableSet().apply { removeAll(graph[pivot] ?: emptySet()) }

        for (vertex in possibles) {
            // Create a new clique including 'vertex'
            val newCliques = currentClique.toMutableSet().apply { add(vertex) }

            // 'newCandidates' are the members of 'candidates' that are neighbors of 'vertex'
            val neighbors = graph[vertex] ?: emptySet()
            val newCandidates = candidates.toMutableSet().apply { retainAll(neighbors) }

            // 'newProcessedVertices' are members of 'processedVertices' that are neighbors of 'vertex'
            val newProcessedVertices = processedVertices.toMutableSet().apply { retainAll(neighbors) }

            // Recursive call with the updated sets
            bronKerbosch(newCliques, newCandidates, newProcessedVertices, graph)

            // Move 'vertex' from 'candidates' to 'processedVertices'
            candidates.remove(vertex)
            processedVertices.add(vertex)
        }
    }

    private val listComparator = Comparator<Any> { list1, list2 ->
        val typedList1 = list1 as List<String>
        val typedList2 = list2 as List<String>
        for (i in 0 until minOf(typedList1.size, typedList2.size)) {
            val comparison = typedList1[i].compareTo(typedList2[i])
            if (comparison != 0) {
                return@Comparator comparison
            }
        }
        typedList1.size.compareTo(typedList2.size)
    }

    private data class Edge(val start: String, val end: String)
}

