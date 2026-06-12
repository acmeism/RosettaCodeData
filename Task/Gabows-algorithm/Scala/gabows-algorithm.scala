import scala.collection.mutable
import scala.annotation.tailrec

final class Digraph(val vertexCount: Int) {
  private val adjacencyLists: Array[mutable.ListBuffer[Int]] = Array.fill(vertexCount)(mutable.ListBuffer.empty[Int])
  private var _edgeCount: Int = 0

  def addEdge(from: Int, to: Int): Unit = {
    validateVertex(from)
    validateVertex(to)
    adjacencyLists(from) += to
    _edgeCount += 1
  }

  def edgeCount: Int = _edgeCount

  def adjacencyList(vertex: Int): Seq[Int] = adjacencyLists(vertex).toList

  private def validateVertex(vertex: Int): Unit = {
    if (vertex < 0 || vertex >= vertexCount)
      throw new IllegalArgumentException(s"Vertex $vertex is not between 0 and ${vertexCount - 1}")
  }

  override def toString: String = {
    val header = s"Digraph has $vertexCount vertices and $edgeCount edges\nAdjacency lists:\n"
    val adjListStr = adjacencyLists.zipWithIndex.map { case (list, idx) =>
      s"${if (idx < 10) " " else ""}$idx: ${list.sorted.mkString(" ")}"
    }.mkString("\n")
    header + adjListStr
  }
}

final class GabowSCC(digraph: Digraph) {
  private val NONE: Int = -1
  private val visited: mutable.ArraySeq[Boolean] = mutable.ArraySeq.fill(digraph.vertexCount)(false)
  private val componentIDs: mutable.ArraySeq[Int] = mutable.ArraySeq.fill(digraph.vertexCount)(NONE)
  private val preorders: mutable.ArraySeq[Int] = mutable.ArraySeq.fill(digraph.vertexCount)(NONE)
  private var preorderCount: Int = 0
  private var sccCount: Int = 0
  private val visitedVerticesStack: mutable.Stack[Int] = mutable.Stack.empty[Int]
  private val auxiliaryStack: mutable.Stack[Int] = mutable.Stack.empty[Int]

  for (vertex <- 0 until digraph.vertexCount if !visited(vertex)) {
    depthFirstSearch(digraph, vertex)
  }

  private def depthFirstSearch(digraph: Digraph, vertex: Int): Unit = {
    visited(vertex) = true
    preorders(vertex) = preorderCount
    preorderCount += 1
    visitedVerticesStack.push(vertex)
    auxiliaryStack.push(vertex)

    digraph.adjacencyList(vertex).foreach { w =>
      if (!visited(w)) {
        depthFirstSearch(digraph, w)
      } else if (componentIDs(w) == NONE) {
        while (auxiliaryStack.nonEmpty && preorders(auxiliaryStack.top) > preorders(w)) {
          auxiliaryStack.pop()
        }
      }
    }

    if (auxiliaryStack.nonEmpty && auxiliaryStack.top == vertex) {
      auxiliaryStack.pop()
      var w = visitedVerticesStack.pop()
      componentIDs(w) = sccCount
      while (w != vertex) {
        w = visitedVerticesStack.pop()
        componentIDs(w) = sccCount
      }
      sccCount += 1
    }
  }

  def components: List[List[Int]] = {
    val components = Array.fill(sccCount)(mutable.ListBuffer.empty[Int])
    for (vertex <- 0 until digraph.vertexCount) {
      val id = componentIDs(vertex)
      if (id == NONE)
        throw new IllegalStateException(s"Vertex $vertex has no SCC ID assigned.")
      else
        components(id) += vertex
    }
    components.map(_.toList).toList
  }

  def isStronglyConnected(v: Int, w: Int): Boolean = {
    validateVertex(v)
    validateVertex(w)
    componentIDs(v) != NONE && componentIDs(v) == componentIDs(w)
  }

  def componentID(vertex: Int): Int = {
    validateVertex(vertex)
    componentIDs(vertex)
  }

  def stronglyConnectedComponentCount: Int = sccCount

  private def validateVertex(vertex: Int): Unit = {
    if (vertex < 0 || vertex >= digraph.vertexCount)
      throw new IllegalArgumentException(s"Vertex $vertex is not between 0 and ${digraph.vertexCount - 1}")
  }
}

object GabowsAlgorithm extends App {
  case class Edge(from: Int, to: Int)

  val edges = List(
    Edge(4, 2), Edge(2, 3), Edge(3, 2), Edge(6, 0), Edge(0, 1),
    Edge(2, 0), Edge(11, 12), Edge(12, 9), Edge(9, 10), Edge(9, 11), Edge(8, 9),
    Edge(10, 12), Edge(0, 5), Edge(5, 4), Edge(3, 5), Edge(6, 4), Edge(6, 9),
    Edge(7, 6), Edge(7, 8), Edge(8, 7), Edge(5, 3), Edge(0, 6)
  )

  val digraph = new Digraph(13)
  edges.foreach(edge => digraph.addEdge(edge.from, edge.to))
  println("Constructed digraph:")
  println(digraph)

  val gabowSCC = new GabowSCC(digraph)
  println(s"It has ${gabowSCC.stronglyConnectedComponentCount} strongly connected components.")

  val components = gabowSCC.components
  println("\nComponents:")
  components.zipWithIndex.foreach { case (comp, idx) =>
    println(s"Component $idx: ${comp.mkString(" ")}")
  }

  println("\nExample connectivity checks:")
  println(s"Vertices 0 and 3 strongly connected? ${gabowSCC.isStronglyConnected(0, 3)}")
  println(s"Vertices 0 and 7 strongly connected? ${gabowSCC.isStronglyConnected(0, 7)}")
  println(s"Vertices 9 and 12 strongly connected? ${gabowSCC.isStronglyConnected(9, 12)}")
  println(s"Component ID of vertex 5: ${gabowSCC.componentID(5)}")
  println(s"Component ID of vertex 8: ${gabowSCC.componentID(8)}")
}
