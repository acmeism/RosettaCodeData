import "./dynamic" for Struct
import "./fmt" for Fmt

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

var Route = Struct.create("Route", ["cost", "fromy", "fromx"])
var zeroRoute = Route.new(0, 0, 0)
var routes = []  // route for each gmooh[][]

var equalRoutes = Fn.new { |r1, r2| r1.cost == r2.cost && r1.fromy == r2.fromy && r1.fromx == r2.fromx }

var search = Fn.new  { |y, x|
    // Simple breadth-first search, populates routes.
    // This isn't strictly Dijkstra because graph edges are not weighted.
    var cost = 0
    routes = List.filled(height, null)
    for (i in 0...height) {
        routes[i] = List.filled(width, null)
        for (j in 0...width) routes[i][j] = Route.new(0, 0, 0)
    }
    routes[y][x] = Route.new(0, y, x)  // zero-cost, the starting point
    var next = []
    while (true) {
        var n = gmooh[y][x].bytes[0] - 48
        for (di in 0...d.count) {
            var dx = d[di][0]
            var dy = d[di][1]
            var rx = x + n * dx
            var ry = y + n * dy
            if (rx >= 0 && rx < width && ry >= 0 && ry < height && gmooh[rx][ry].bytes[0] >= 48) {
                var ryx = routes[ry][rx]
                if (equalRoutes.call(ryx, zeroRoute) || ryx.cost > cost+1) {
                    routes[ry][rx] = Route.new(cost + 1, y, x)
                    if (gmooh[ry][rx].bytes[0] > 48) {
                        next.add(Route.new(cost + 1, ry, rx))
                        // If the graph was weighted, at this point
                        // that would get shuffled up into place.
                    }
                }
            }
        }
        if (next.count == 0) break
        cost = next[0].cost
        y    = next[0].fromy
        x    = next[0].fromx
        next.removeAt(0)
    }
}

var getRoute = Fn.new { |y, x|
    var cost = 0
    var res = [[y, x]]
    while(true) {
        cost = routes[y][x].cost
        var oldy = y
        y = routes[y][x].fromy
        x = routes[oldy][x].fromx
        if (cost == 0) break
        res.insert(0, [y, x])
    }
    return res
}

var showShortest = Fn.new {
    var shortest = 9999
    var res = []
    for (x in 0...width) {
        for (y in 0...height) {
            if (gmooh[y][x] == "0") {
                var ryx = routes[y][x]
                if (!equalRoutes.call(ryx, zeroRoute)) {
                    var cost = ryx.cost
                    if (cost <= shortest) {
                        if (cost < shortest) {
                            res.clear()
                            shortest = cost
                        }
                        res.add([y, x])
                    }
                }
            }
        }
    }
    var areis = (res.count > 1) ? "are" :"is"
    var s     = (res.count > 1) ? "s" : ""
    Fmt.print("There $s $d shortest route$s of $d days to safety:", areis, res.count, s, shortest)
    for (r in res) System.print(getRoute.call(r[0], r[1]))
}

var showUnreachable = Fn.new {
    var res = []
    for (x in 0...width) {
        for (y in 0...height) {
            if (gmooh[y][x].bytes[0] >= 48 && equalRoutes.call(routes[y][x], zeroRoute)) {
                res.add([y, x])
            }
        }
    }
    System.print("\nThe following cells are unreachable:")
    System.print(res)
}

var showLongest = Fn.new {
    var longest = 0
    var res = []
    for (x in 0...width) {
        for (y in 0...height) {
            if (gmooh[y][x].bytes[0] >= 48) {
                var ryx = routes[y][x]
                if (!equalRoutes.call(ryx, zeroRoute)) {
                    var rl = ryx.cost
                    if (rl >= longest) {
                        if (rl > longest) {
                            res.clear()
                            longest = rl
                        }
                        res.add([y, x])
                    }
                }
            }
        }
    }
    Fmt.print("\nThere are $d cells that take $d days to send reinforcements to:\n", res.count, longest)
    for (r in res) System.print(getRoute.call(r[0], r[1]))
}

search.call(11, 11)
showShortest.call()

search.call(21, 11)
System.print("\nThe shortest route from [21,11] to [1,11]:")
System.print(getRoute.call(1, 11))

search.call(1, 11)
System.print("\nThe shortest route from [1,11] to [21,11]:")
System.print(getRoute.call(21, 11))

search.call(11, 11)
showUnreachable.call()
showLongest.call()
