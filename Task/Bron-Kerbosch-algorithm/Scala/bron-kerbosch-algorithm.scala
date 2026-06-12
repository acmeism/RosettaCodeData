import scala.collection.mutable
import scala.collection.immutable.TreeSet

object BronKerboschAlgorithm {

  case class Edge(start: String, end: String)

  private var cliques: mutable.ListBuffer[List[String]] = mutable.ListBuffer.empty[List[String]]

  def main(args: Array[String]): Unit = {
    val edges = List(
      Edge("a", "b"), Edge("b", "a"), Edge("a", "c"), Edge("c", "a"),
      Edge("b", "c"), Edge("c", "b"), Edge("d", "e"), Edge("e", "d"),
      Edge("d", "f"), Edge("f", "d"), Edge("e", "f"), Edge("f", "e")
    )

    // Build the graph as an adjacency list
    val graph: mutable.Map[String, mutable.Set[String]] = mutable.Map.empty
    edges.foreach { edge =>
      graph.getOrElseUpdate(edge.start, mutable.Set.empty[String]).add(edge.end)
    }

    // Initialize current clique, candidates and processed vertices
    val currentClique: TreeSet[String] = TreeSet.empty[String]
    val candidates: mutable.Set[String] = mutable.Set(graph.keySet.toSeq: _*)
    val processedVertices: mutable.Set[String] = mutable.Set.empty[String]

    // Execute the Bron-Kerbosch algorithm to collect the cliques
    val immutableGraph = graph.map { case (k, v) => k -> v.toSet }.toMap
    bronKerbosch(currentClique, candidates, processedVertices, immutableGraph)

    // Sort the cliques for consistent display
    cliques = cliques.sortWith(listComparator)

    // Display the cliques
    println(cliques.toList)
  }

  private def bronKerbosch(
    currentClique: TreeSet[String],
    candidates: mutable.Set[String],
    processedVertices: mutable.Set[String],
    graph: Map[String, Set[String]]
  ): Unit = {

    if (candidates.isEmpty && processedVertices.isEmpty) {
      if (currentClique.size > 2) {
        val clique = currentClique.toList
        cliques += clique
      }
      return
    }

    // Select a pivot vertex from 'candidates' union 'processedVertices' with the maximum degree
    val union = candidates ++ processedVertices
    val pivot = union.maxBy(vertex => graph(vertex).size)

    // 'possibles' are vertices in 'candidates' that are not neighbours of the 'pivot'
    val possibles = candidates -- graph(pivot)

    for (vertex <- possibles.toList) { // Convert to List to avoid concurrent modification
      // Create a new clique including 'vertex'
      val newCliques = currentClique + vertex

      // 'newCandidates' are the members of 'candidates' that are neighbours of 'vertex'
      val neighbours = graph(vertex)
      val newCandidates = candidates.intersect(neighbours)

      // 'newProcessedVertices' are members of 'processedVertices' that are neighbours of 'vertex'
      val newProcessedVertices = processedVertices.intersect(neighbours)

      // Recursive call with the updated sets
      bronKerbosch(newCliques, newCandidates, newProcessedVertices, graph)

      // Move 'vertex' from 'candidates' to 'processedVertices'
      candidates.remove(vertex)
      processedVertices.add(vertex)
    }
  }

  private def listComparator(list1: List[String], list2: List[String]): Boolean = {
    val minSize = math.min(list1.size, list2.size)
    for (i <- 0 until minSize) {
      val comparison = list1(i).compare(list2(i))
      if (comparison != 0) {
        return comparison < 0
      }
    }
    list1.size < list2.size
  }
}
