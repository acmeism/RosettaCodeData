import scala.collection.mutable
import scala.util.control.Breaks._

case class Edge(u: Int, v: Int, weight: Double)

class Graph(vertexCount: Int) {
  private val edges = mutable.ListBuffer[Edge]()

  def addEdge(edge: Edge): Unit = {
    edges += edge
  }

  def borůvkaMinimumSpanningTree(): Unit = {
    val parent = (0 until vertexCount).toArray
    val rank = Array.fill(vertexCount)(0)

    // Store the cheapest edge of each tree
    var cheapest = Array.fill(vertexCount)(Edge(-1, -1, -1.0))

    // Initially there are 'vertexCount' different trees
    var treeCount = vertexCount
    var minimumSpanningTreeWeight = 0.0

    // Combine trees until all trees are combined into a single minimum spanning tree
    while (treeCount > 1) {
      // Reset cheapest edges for this iteration
      cheapest = Array.fill(vertexCount)(Edge(-1, -1, -1.0))

      // Traverse through all edges and update cheapest edge for every tree
      edges.foreach { edge =>
        val Edge(u, v, weight) = edge

        val index1 = find(parent, u)
        val index2 = find(parent, v)

        // If the two vertices of the current edge belong to different trees,
        // check whether the current edge is cheaper than previous cheapest edges
        if (index1 != index2) {
          if (cheapest(index1).weight == -1.0 || cheapest(index1).weight > weight) {
            cheapest(index1) = Edge(u, v, weight)
          }
          if (cheapest(index2).weight == -1.0 || cheapest(index2).weight > weight) {
            cheapest(index2) = Edge(u, v, weight)
          }
        }
      }

      // Add the cheapest edges to the minimum spanning tree
      for (vertex <- 0 until vertexCount) {
        // Check whether the cheapest edge for current vertex exists
        if (cheapest(vertex).weight != -1.0) {
          val Edge(u, v, weight) = cheapest(vertex)

          val index1 = find(parent, u)
          val index2 = find(parent, v)

          if (index1 != index2) {
            minimumSpanningTreeWeight += weight
            unionSet(parent, rank, index1, index2)
            println(s"Edge $u--$v with weight $weight is included in the minimum spanning tree")
            treeCount -= 1
          }
        }
      }
    }

    println(s"\nWeight of minimum spanning tree is $minimumSpanningTreeWeight")
  }

  // Return the index of the tree containing 'vertex', using path compression technique
  private def find(parent: Array[Int], vertex: Int): Int = {
    if (parent(vertex) != vertex) {
      parent(vertex) = find(parent, parent(vertex))
    }
    parent(vertex)
  }

  // Form the union by rank of the two trees indexed by u and v
  private def unionSet(parent: Array[Int], rank: Array[Int], u: Int, v: Int): Unit = {
    val uRoot = find(parent, u)
    val vRoot = find(parent, v)

    // Attach the smaller rank tree under root of the high rank tree
    rank(uRoot) compare rank(vRoot) match {
      case -1 => parent(uRoot) = vRoot
      case 1  => parent(vRoot) = uRoot
      case 0  =>
        parent(vRoot) = uRoot
        rank(uRoot) += 1
    }
  }
}

object BorůvkaAlgorithm {
  def main(args: Array[String]): Unit = {
    val graph = new Graph(4)
    graph.addEdge(Edge(0, 1, 10.0))
    graph.addEdge(Edge(0, 2, 6.0))
    graph.addEdge(Edge(0, 3, 5.0))
    graph.addEdge(Edge(1, 3, 15.0))
    graph.addEdge(Edge(2, 3, 4.0))

    graph.borůvkaMinimumSpanningTree()
  }
}
