import scala.collection.mutable.Stack
import scala.collection.mutable.ListBuffer

object HierholzerAlgorithm {
  def main(args: Array[String]): Unit = {
    val adjacencyList1 = ListBuffer(List(1), List(2), List(0))
    printCircuit(adjacencyList1)

    val adjacencyList2 = ListBuffer(List(1, 6), List(2), List(0, 3), List(4), List(2, 5), List(0), List(4))
    printCircuit(adjacencyList2)
  }

  def printCircuit(adjacencyList: ListBuffer[List[Int]]): Unit = {
    if (adjacencyList.isEmpty) {
      return
    }

    val path = Stack[Int]()
    val circuit = ListBuffer[Int]()

    var currentVertex = 0 // Start at vertex 0
    path.push(currentVertex)

    while (path.nonEmpty) {
      if (adjacencyList(currentVertex).nonEmpty) {
        path.push(currentVertex)
        val nextVertex = adjacencyList(currentVertex).last
        adjacencyList(currentVertex) = adjacencyList(currentVertex).init
        currentVertex = nextVertex
      } else { // Back-tracking
        circuit += currentVertex
        currentVertex = path.pop()
      }
    }

    // Print the circuit
    println(circuit.reverse.mkString(" => "))
  }
}

