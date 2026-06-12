import java.util.Stack

fun main() {
    val adjacencyList1 = mutableListOf<MutableList<Int>>()
    adjacencyList1.add(mutableListOf(1))
    adjacencyList1.add(mutableListOf(2))
    adjacencyList1.add(mutableListOf(0))

    printCircuit(adjacencyList1)

    val adjacencyList2 = mutableListOf<MutableList<Int>>()
    adjacencyList2.add(mutableListOf(1, 6))
    adjacencyList2.add(mutableListOf(2))
    adjacencyList2.add(mutableListOf(0, 3))
    adjacencyList2.add(mutableListOf(4))
    adjacencyList2.add(mutableListOf(2, 5))
    adjacencyList2.add(mutableListOf(0))
    adjacencyList2.add(mutableListOf(4))

    printCircuit(adjacencyList2)
}

fun printCircuit(adjacencyList: MutableList<MutableList<Int>>) {
    if (adjacencyList.isEmpty()) {
        return
    }

    val path = Stack<Int>()
    val circuit = mutableListOf<Int>()

    var currentVertex = 0 // Start at vertex 0
    path.push(currentVertex)

    while (path.isNotEmpty()) {
        if (adjacencyList[currentVertex].isNotEmpty()) {
            path.push(currentVertex)
            val nextVertex = adjacencyList[currentVertex].last()
            adjacencyList[currentVertex].removeAt(adjacencyList[currentVertex].size - 1)
            currentVertex = nextVertex
        } else { // Back-tracking
            circuit.add(currentVertex)
            currentVertex = path.pop()
        }
    }

    // Print the circuit
    for (i in circuit.size - 1 downTo 0) {
        print(circuit[i])
        if (i != 0) {
            print(" => ")
        }
    }
    println()
}

