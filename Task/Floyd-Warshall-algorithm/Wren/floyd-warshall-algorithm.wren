import "./fmt" for Fmt

class FloydWarshall {
    static doCalcs(weights, nVertices) {
        var dist = List.filled(nVertices, null)
        for (i in 0...nVertices) dist[i] = List.filled(nVertices, 1/0)
        for (w in weights) dist[w[0] - 1][w[1] - 1] = w[2]
        var next = List.filled(nVertices, null)
        for (i in 0...nVertices) next[i] = List.filled(nVertices, 0)
        for (i in 0...next.count) {
            for (j in 0...next.count) {
                if (i != j) next[i][j] = j + 1
            }
        }
        for (k in 0...nVertices) {
            for (i in 0...nVertices) {
                for (j in 0...nVertices) {
                    if (dist[i][k] + dist[k][j] < dist[i][j]) {
                        dist[i][j] = dist[i][k] + dist[k][j]
                        next[i][j] = next[i][k]
                    }
                }
            }
        }
        printResult_(dist, next)
    }

    static printResult_(dist,  next) {
        System.print("pair     dist    path")
        for (i in 0...next.count) {
            for (j in 0...next.count) {
                if (i != j) {
                    var u = i + 1
                    var v = j + 1
                    var path = Fmt.swrite("$d -> $d    $2d     $s", u, v, dist[i][j].truncate, u)
                    while (true) {
                        u = next[u - 1][v - 1]
                        path = path +  " -> " + u.toString
                        if (u == v) break
                    }
                    System.print(path)
                }
            }
        }
    }
}

var weights = [ [1, 3, -2], [2, 1, 4], [2, 3, 3], [3, 4, 2], [4, 2, -1] ]
var nVertices = 4
FloydWarshall.doCalcs(weights, nVertices)
