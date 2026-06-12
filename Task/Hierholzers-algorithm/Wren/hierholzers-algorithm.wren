import "./seq" for Stack

/* Function to print the Eulerian circuit */
var printCircuit = Fn.new { |adj|

    // if the adjacency list is empty, do nothing
    if (adj.isEmpty) return

    var currPath = Stack.new()
    var circuit = Stack.new()
    currPath.push(0)  // start with vertex 0
    while (!currPath.isEmpty) {
        var currV = currPath.peek()
        if (!adj[currV].isEmpty) {
            // get the next vertex from the adjacency list
            var nextV = adj[currV][0]
            adj[currV].removeAt(0)  // remove the edge
            currPath.push(nextV)
        } else {
            // backtrack and add to the circuit
            circuit.push(currPath.pop())
        }
    }

    // print the circuit in reverse order
    var printStack  // recursive
    printStack = Fn.new { |s|
        if (!s.isEmpty) {
            System.write(s.pop())
            if (!s.isEmpty) System.write(" -> ")
            printStack.call(s)
        }
    }
    printStack.call(circuit)
    System.print()
}

// first adjacency list
var adj1 = [ [1], [2], [0] ]
printCircuit.call(adj1)

// second adjacency list
var adj2 = [ [1, 6], [2], [0, 3], [4], [2, 5], [0], [4] ]
printCircuit.call(adj2)
