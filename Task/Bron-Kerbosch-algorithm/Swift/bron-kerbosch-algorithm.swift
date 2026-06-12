var cliques: [[String]] = []

struct Edge {
    let start: String
    let end: String
}

func bronKerbosch(currentClique: Set<String>, candidates: Set<String>, processedVertices: Set<String>, graph: [String: Set<String>]) {
    if candidates.isEmpty && processedVertices.isEmpty {
        if currentClique.count > 2 {
            let clique = Array(currentClique).sorted()
            cliques.append(clique)
        }
        return
    }

    let union = candidates.union(processedVertices)
    let pivot = union.max(by: { graph[$0]!.count < graph[$1]!.count })!

    let possibles = candidates.subtracting(graph[pivot]!)

    for vertex in possibles {
        var newClique = currentClique
        newClique.insert(vertex)

        let neighbors = graph[vertex]!
        let newCandidates = candidates.intersection(neighbors)
        let newProcessedVertices = processedVertices.intersection(neighbors)

        bronKerbosch(currentClique: newClique, candidates: newCandidates, processedVertices: newProcessedVertices, graph: graph)

        var newCandidatesSet = candidates
        newCandidatesSet.remove(vertex)

        var newProcessedVerticesSet = processedVertices
        newProcessedVerticesSet.insert(vertex)

        bronKerbosch(currentClique: currentClique, candidates: newCandidatesSet, processedVertices: newProcessedVerticesSet, graph: graph)
    }
}

func main() {
    let edges = [
        Edge(start: "a", end: "b"), Edge(start: "b", end: "a"),
        Edge(start: "a", end: "c"), Edge(start: "c", end: "a"),
        Edge(start: "b", end: "c"), Edge(start: "c", end: "b"),
        Edge(start: "d", end: "e"), Edge(start: "e", end: "d"),
        Edge(start: "d", end: "f"), Edge(start: "f", end: "d"),
        Edge(start: "e", end: "f"), Edge(start: "f", end: "e")
    ]

    var graph: [String: Set<String>] = [:]
    for edge in edges {
        if graph[edge.start] == nil {
            graph[edge.start] = Set<String>()
        }
        graph[edge.start]?.insert(edge.end)
    }

    let currentClique = Set<String>()
    let candidates = Set<String>(graph.keys)
    let processedVertices = Set<String>()

    bronKerbosch(currentClique: currentClique, candidates: candidates, processedVertices: processedVertices, graph: graph)

    cliques.sort { (list1, list2) -> Bool in
        for i in 0..<min(list1.count, list2.count) {
            if list1[i] != list2[i] {
                return list1[i] < list2[i]
            }
        }
        return list1.count < list2.count
    }

    // Remove duplicates
    var uniqueCliques = [[String]]()
    var seen = Set<Set<String>>()

    for clique in cliques {
        let cliqueSet = Set(clique)
        if !seen.contains(cliqueSet) {
            seen.insert(cliqueSet)
            uniqueCliques.append(clique)
        }
    }

    print(uniqueCliques)
}

main()

