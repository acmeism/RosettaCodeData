var Equals  = Fn.new { |p1, p2| p1[0] == p2[0] && p1[1] == p2[1] }

var Contains = Fn.new { |pairs, p|
    for (pair in pairs) {
        if (Equals.call(p, pair)) return true
    }
    return false
}

var Remove = Fn.new { |pairs, p|
    for (pair in pairs) {
        if (Equals.call(p, pair)) {
            pairs.remove(pair)
            return
        }
    }
}

class AStarGraph {
    construct new() {
        _barriers = [[2,4], [2,5], [2,6], [3,6], [4,6], [5,6], [5,5], [5,4], [5,3], [5,2], [4,2], [3,2]]
    }

    barriers { _barriers }

    heuristic(start, goal) {
        var D1 = 1
        var D2 = 1
        var dx = (start[0] - goal[0]).abs
        var dy = (start[1] - goal[1]).abs
        return D1 * (dx + dy) + (D2 - 2*D1) * dx.min(dy)
    }

    getVertexNeighbors(pos) {
        var n = []
        for (d in [[1,0], [-1,0], [0,1], [0,-1], [1,1], [-1,1], [1,-1], [-1,-1]]) {
            var x2 = pos[0] + d[0]
            var y2 = pos[1] + d[1]
            if (x2 < 0 || x2 > 7 || y2 < 0 || y2 > 7) continue
            n.add([x2, y2])
        }
        return n
    }

    moveCost(b) { Contains.call(_barriers, b) ? 100 : 1 }
}

var AStarSearch = Fn.new { |start, end, graph|
    var G = {start.toString: 0}
    var F = {start.toString: graph.heuristic(start, end)}
    var closedVertices = []
    var openVertices = [start]
    var cameFrom  = {}
    while (openVertices.count > 0) {
        var current = null
        var currentFscore = 1 / 0
        for (pos in openVertices) {
            var v
            if ((v = F[pos.toString]) && v && v < currentFscore) {
                currentFscore = v
                current = pos
            }
        }
        if (Equals.call(current, end)) {
            var path = [current]
            while (cameFrom.containsKey(current.toString)) {
                current = cameFrom[current.toString]
                path.add(current)
            }
            path = path[-1..0]
            return [path, F[end.toString]]
        }
        Remove.call(openVertices, current)
        closedVertices.add(current)
        for (neighbor in graph.getVertexNeighbors(current)) {
            if (Contains.call(closedVertices, neighbor)) continue
            var candidateG = G[current.toString] + graph.moveCost(neighbor)
            if (!Contains.call(openVertices, neighbor)) {
                openVertices.add(neighbor)
            } else if (candidateG >= G[neighbor.toString]) continue
            cameFrom[neighbor.toString] = current
            G[neighbor.toString] = candidateG
            var H = graph.heuristic(neighbor, end)
            F[neighbor.toString] = G[neighbor.toString] + H
        }
    }
    Fiber.abort("A* failed to find a solution")
}

var graph = AStarGraph.new()
var rc = AStarSearch.call([0,0], [7,7], graph)
var route = rc[0]
var cost = rc[1]
var w = 10
var h = 10
var grid = List.filled(h, null)
for (i in 0...h) grid[i] = List.filled(w, ".")
for (y in 0...h) {
    grid[y][0]  = "█"
    grid[y][-1] = "█"
}
for (x in 0...w) {
    grid[0][x]  = "█"
    grid[-1][x] = "█"
}
for (p in graph.barriers) {
    var x = p[0]
    var y = p[1]
    grid[x+1][y+1] = "█"
}
for (p in route) {
    var x = p[0]
    var y = p[1]
    grid[x+1][y+1] = "x"
}
for (line in grid) System.print(line.join())
System.print("\npath cost %(cost): %(route)")
