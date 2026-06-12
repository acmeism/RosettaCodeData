import scala.collection.mutable
import scala.collection.mutable.PriorityQueue
import scala.util.{Success, Try}

object JohnsonsAlgorithm {

  private val INF = Double.MaxValue

  case class Edge(u: Int, v: Int, weight: Double)
  case class VertexAndWeight(vertex: Int, weight: Double)

  def main(args: Array[String]): Unit = {
    // The element (i, j) is the weight of the edge from vertex i to vertex j.
    // INF, for infinity, means that there is no edge from vertex i to vertex j.
    val graph = Vector(
      Vector( 0.0, -5.0, 2.0, 3.0 ),
      Vector( INF,  0.0, 4.0, INF ),
      Vector( INF,  INF, 0.0, 1.0 ),
      Vector( INF,  INF, INF, 0.0 )
    )

    johnsonsAlgorithm(graph) match {
      case Some(result) =>
        println("All pairs shortest paths:")
        println("The element (i, j) is the shortest path between vertex i and vertex j.")
        result.foreach { row =>
          print("[")
          row.foreach { number =>
            print(if (number == INF) "INF " else s"$number ")
          }
          println("]")
        }
      case None =>
        println("A negative cycle was detected in the graph.")
    }
  }

  /**
   * Return the shortest path between all pairs of vertices in an edge weighted directed graph
   * For a full description of the algorithm visit https://en.wikipedia.org/wiki/Johnson%27s_algorithm
   */
  def johnsonsAlgorithm(graph: Vector[Vector[Double]]): Option[Vector[Vector[Double]]] = {
    val vertexCount = graph.length

    // Step 0: Build a list of edges for the original graph
    val originalEdges = (for {
      i <- graph.indices
      j <- graph.indices
      weight = graph(i)(j)
      if i != j && weight != INF
    } yield {
      if (i == j && weight != 0.0) {
        println(s"Warning: graph[$i][$i] is $weight, expected to be 0.0, resetting it to 0.0")
      }
      Edge(i, j, weight)
    }).toVector

    // Step 1: Form the augmented graph
    // Add a new vertex with index 'vertexCount' and having 0-weight edges to all the original vertices
    val augmentedEdges = originalEdges ++ (0 until vertexCount).map(i => Edge(vertexCount, i, 0.0))

    // Step 2: Invoke the Bellman-Ford Algorithm starting from the new vertex
    bellmanFordAlgorithm(vertexCount + 1, augmentedEdges, vertexCount) match {
      case None => None // A negative cycle was detected
      case Some(hValues) =>
        val values = hValues.dropRight(1) // Remove the value for the augmented vertex

        // Step 3: Reweight the edges
        val reweightedAdjacencies = mutable.Map.empty[Int, mutable.ListBuffer[VertexAndWeight]]
        (0 until vertexCount).foreach(v => reweightedAdjacencies(v) = mutable.ListBuffer.empty)

        originalEdges.foreach { edge =>
          // Ensure the 'values' are valid before reweighting
          if (values(edge.u) == INF || values(edge.v) == INF) {
            println("Warning: invalid hValues detected by the Bellman-Ford Algorithm.")
          }

          val reweight = edge.weight + values(edge.u) - values(edge.v)
          reweightedAdjacencies(edge.u) += VertexAndWeight(edge.v, reweight)
        }

        // Step 4: Invoke Dijkstra's Algorithm starting from each vertex on the reweighted graph
        val allPairsShortestPaths = (0 until vertexCount).map { u =>
          dijkstraAlgorithm(vertexCount, reweightedAdjacencies.toMap, u, values)
        }.toVector

        // Step 5: Return the result matrix
        Some(allPairsShortestPaths)
    }
  }

  /**
   * Return a list of shortest distances from the source vertex to all other vertices,
   * or None if a negative cycle is detected
   */
  def bellmanFordAlgorithm(augmentedVertexCount: Int, edges: Vector[Edge], sourceVertex: Int): Option[Vector[Double]] = {
    val distances = Array.fill(augmentedVertexCount)(INF)
    distances(sourceVertex) = 0.0

    // Relax the edges (augmentedVertexCount - 1) times
    var updated = true
    for (i <- 0 until augmentedVertexCount - 1 if updated) {
      updated = false
      edges.foreach { edge =>
        if (distances(edge.u) != INF && distances(edge.u) + edge.weight < distances(edge.v)) {
          distances(edge.v) = distances(edge.u) + edge.weight
          updated = true
        }
      }
    }

    // Check for negative cycles in the graph
    val hasNegativeCycle = edges.exists { edge =>
      distances(edge.u) != INF && distances(edge.u) + edge.weight < distances(edge.v)
    }

    if (hasNegativeCycle) None else Some(distances.toVector)
  }

  /**
   * Return a list of shortest path distances from the source vertex in the original graph to all other vertices
   */
  def dijkstraAlgorithm(vertexCount: Int,
                       reweightedAdjacencies: Map[Int, mutable.ListBuffer[VertexAndWeight]],
                       sourceVertex: Int,
                       values: Vector[Double]): Vector[Double] = {

    val distances = Array.fill(vertexCount)(INF)
    distances(sourceVertex) = 0.0

    // Use reverse ordering for min-heap behavior
    implicit val ordering: Ordering[VertexAndWeight] = Ordering.by[VertexAndWeight, Double](_.weight).reverse
    val priorityQueue = mutable.PriorityQueue[VertexAndWeight]()
    priorityQueue.enqueue(VertexAndWeight(sourceVertex, 0.0))

    val finalDistances = Array.fill(vertexCount)(INF)

    while (priorityQueue.nonEmpty) {
      val VertexAndWeight(vertex, weight) = priorityQueue.dequeue()

      if (weight <= distances(vertex)) {
        // Store the final shortest path distance, translated back to the distance in the original graph
        if (finalDistances(vertex) == INF) {
          if (distances(vertex) == INF) { // Safety check
            finalDistances(vertex) = INF
          } else {
            // Translate distance back to its original weight: d(u,v) = d'(u,v) - h[u] + h[v]
            finalDistances(vertex) = distances(vertex) - values(sourceVertex) + values(vertex)
          }
        }

        // Relax the edges outgoing from vertex
        reweightedAdjacencies.get(vertex).foreach { adjacentVertices =>
          adjacentVertices.foreach { case VertexAndWeight(adjVertex, adjWeight) =>
            if (distances(vertex) != INF && distances(vertex) + adjWeight < distances(adjVertex)) {
              distances(adjVertex) = distances(vertex) + adjWeight
              priorityQueue.enqueue(VertexAndWeight(adjVertex, distances(adjVertex)))
            }
          }
        }
      }
    }

    // Translate distance back to its original weight for any remaining reachable vertices
    (0 until vertexCount).foreach { i =>
      if (finalDistances(i) == INF && distances(i) != INF) {
        finalDistances(i) = distances(i) - values(sourceVertex) + values(i)
      }
    }

    finalDistances.toVector
  }
}
