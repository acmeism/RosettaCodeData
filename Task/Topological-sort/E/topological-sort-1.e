def makeQueue := <elib:vat.makeQueue>

def topoSort(data :Map[any, Set[any]]) {
    # Tables of nodes and edges
    def forwardEdges := [].asMap().diverge()
    def reverseCount := [].asMap().diverge()

    def init(node) {
      reverseCount[node] := 0
      forwardEdges[node] := [].asSet().diverge()
    }
    for node => deps in data {
        init(node)
        for dep in deps { init(dep) }
    }

    # 'data' holds the dependencies. Compute the other direction.
    for node => deps in data {
        for dep ? (dep != node) in deps {
            forwardEdges[dep].addElement(node)
            reverseCount[node] += 1
        }
    }

    # Queue containing all elements that have no (initial or remaining) incoming edges
    def ready := makeQueue()
    for node => ==0 in reverseCount {
      ready.enqueue(node)
    }

    var result := []

    while (ready.optDequeue() =~ node :notNull) {
        result with= node
        for next in forwardEdges[node] {
            # Decrease count of incoming edges and enqueue if none
            if ((reverseCount[next] -= 1).isZero()) {
                ready.enqueue(next)
            }
        }
        forwardEdges.removeKey(node)
    }

    if (forwardEdges.size().aboveZero()) {
        throw(`Topological sort failed: $forwardEdges remains`)
    }

    return result
}
