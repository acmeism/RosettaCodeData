func printCircuit(_ adjacencyList: inout [[Int]]) {
    guard !adjacencyList.isEmpty else {
        return
    }

    var path: [Int] = []
    var circuit: [Int] = []

    var currentVertex = 0 // Start at vertex 0
    path.append(currentVertex)

    while !path.isEmpty {
        if !adjacencyList[currentVertex].isEmpty {
            path.append(currentVertex)
            let nextVertex = adjacencyList[currentVertex].last!
            adjacencyList[currentVertex].removeLast()
            currentVertex = nextVertex
        } else {
            circuit.append(currentVertex)
            currentVertex = path.removeLast()
        }
    }

    // Print the circuit
    for i in stride(from: circuit.count - 1, through: 0, by: -1) {
        print(circuit[i], terminator: i != 0 ? " => " : "\n")
    }
}

var adjacencyList1 = [
    [1],
    [2],
    [0]
]

printCircuit(&adjacencyList1)

var adjacencyList2 = [
    [1, 6],
    [2],
    [0, 3],
    [4],
    [2, 5],
    [0],
    [4]
]

printCircuit(&adjacencyList2)

