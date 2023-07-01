import "/fmt" for Fmt

var gmooh = """
.........00000.........
......00003130000......
....000321322221000....
...00231222432132200...
..0041433223233211100..
..0232231612142618530..
.003152122326114121200.
.031252235216111132210.
.022211246332311115210.
00113232262121317213200
03152118212313211411110
03231234121132221411410
03513213411311414112320
00427534125412213211400
.013322444412122123210.
.015132331312411123120.
.003333612214233913300.
..0219126511415312570..
..0021321524341325100..
...00211415413523200...
....000122111322000....
......00001120000......
.........00000.........
""".split("\n")

var width  = gmooh[0].count
var height = gmooh.count

var d = [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]]

var dist = []
var next = []
var pmap = []

var max = 2147483647
var min = -1

var fwPath = Fn.new { |u, v|
    var res = ""
    if (next[u][v] != min) {
        var path = [pmap[u].toString]
        while (u != v) {
            u = next[u][v]
            path.add(pmap[u].toString)
        }
        res = path.join("->")
    }
    return res
}

var showFwPath = Fn.new { |u, v|
    Fmt.print("$n->$n  $2d   $s", pmap[u], pmap[v], dist[u][v], fwPath.call(u, v))
}

var floydWarshall = Fn.new {
    var point = 0
    var weights = []
    var points = List.filled(height, null)
    for (i in 0...height) points[i] = List.filled(width, 0)
    // First number the points.
    for (x in 0...width) {
        for (y in 0...width) {
            if (gmooh[y][x].bytes[0] >= 48) {
                points[y][x] = point
                point = point + 1
                pmap.add([y, x])
            }
        }
    }
    // ...and then a set of edges (all of which have a "weight" of 1 day)
    for (x in 0...width) {
        for (y in 0...height) {
            if (gmooh[y][x].bytes[0] > 48) {
                var n = gmooh[y][x].bytes[0] - 48
                for (di in 0...d.count) {
                    var dx = d[di][0]
                    var dy = d[di][1]
                    var rx = x + n * dx
                    var ry = y + n * dy
                    if (rx >= 0 && rx < width && ry >= 0 && ry < height && gmooh[rx][ry].bytes[0] >= 48) {
                        weights.add([points[y][x], points[ry][rx]])
                    }
                }
            }
        }
    }
    // Before applying Floyd-Warshall.
    var vv = pmap.count
    dist = List.filled(vv, null)
    next = List.filled(vv, null)
    for (i in 0...vv) {
        dist[i] = List.filled(vv, 0)
        next[i] = List.filled(vv, 0)
        for (j in 0...vv) {
            dist[i][j] = max
            next[i][j] = min
        }
    }
    for (k in 0...weights.count) {
        var u = weights[k][0]
        var v = weights[k][1]
        dist[u][v] = 1  // the weight of the edge (u,v)
        next[u][v] = v
    }
    // Standard Floyd-Warshall implementation,
    // with the optimization of avoiding processing of self/infs,
    // which surprisingly makes quite a noticeable difference.
    for (k in 0...vv) {
        for (i in 0...vv) {
            if (i != k && dist[i][k] != max) {
                for (j in 0...vv) {
                    if (j != i && j != k && dist[k][j] != max) {
                        var dd  = dist[i][k] + dist[k][j]
                        if (dd < dist[i][j]) {
                            dist[i][j] = dd
                            next[i][j] = next[i][k]
                        }
                    }
                }
            }
        }
    }
    showFwPath.call(points[21][11], points[1][11])
    showFwPath.call(points[1][11], points[21][11])
    var maxd = 0
    var mi   = 0
    var mj   = 0
    for (i in 0...vv) {
        for (j in 0...vv) {
            if (j != i) {
                var dd = dist[i][j]
                if (dd != max && dd > maxd) {
                    maxd = dd
                    mi = i
                    mj = j
                }
            }
        }
    }
    System.print("\nMaximum shortest distance:")
    showFwPath.call(mi, mj)
}

floydWarshall.call()
