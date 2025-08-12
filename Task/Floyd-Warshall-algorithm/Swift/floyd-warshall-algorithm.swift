func floydWarshall(_ weights: [[Int]], _ numVertices: Int) {
    var dist = Array(repeating: Array(repeating: Double.infinity, count: numVertices), count: numVertices)
    var next = Array(repeating: Array(repeating: 0, count: numVertices), count: numVertices)

    for weight in weights {
        dist[weight[0] - 1][weight[1] - 1] = Double(weight[2])
    }

    for i in 0..<numVertices {
        for j in 0..<numVertices {
            if i != j {
                next[i][j] = j + 1
            }
        }
    }

    for k in 0..<numVertices {
        for i in 0..<numVertices {
            for j in 0..<numVertices {
                if dist[i][k] + dist[k][j] < dist[i][j] {
                    dist[i][j] = dist[i][k] + dist[k][j]
                    next[i][j] = next[i][k]
                }
            }
        }
    }

    printResult(dist, next)
}

func printResult(_ dist: [[Double]], _ next: [[Int]]) {
    print("pair     dist    path")
    for i in 0..<next.count {
        for j in 0..<next.count {
            if i != j {
                var u = i + 1
                let v = j + 1
                var path = "\(u) -> \(v)    \(Int(dist[i][j]))     \(u)"
                repeat {
                    u = next[u - 1][v - 1]
                    path += " -> \(u)"
                } while u != v
                print(path)
            }
        }
    }
}

let weights = [[1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1]]
let numVertices = 4
floydWarshall(weights, numVertices)
