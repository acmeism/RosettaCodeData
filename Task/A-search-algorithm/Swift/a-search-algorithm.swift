import Foundation

// ------------------------------------------------------------
// MARK: - Point (equivalent to the C++ class `point`)
// ------------------------------------------------------------
struct Point: Equatable, Hashable {
    var x: Int
    var y: Int

    init(_ x: Int = 0, _ y: Int = 0) {
        self.x = x
        self.y = y
    }

    // overload the + operator
    static func + (lhs: Point, rhs: Point) -> Point {
        return Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }
}

// ------------------------------------------------------------
// MARK: - GridMap (the 8×8 board)
// ------------------------------------------------------------
struct GridMap {
    private let data: [[Int]]          // 0 = free, 1 = wall
    let width = 8
    let height = 8

    init() {
        // raw layout taken directly from the C++ constructor
        let raw: [[Int]] = [
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 1, 1, 0],
            [0, 0, 1, 0, 0, 0, 1, 0],
            [0, 0, 1, 0, 0, 0, 1, 0],
            [0, 0, 1, 1, 1, 1, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 0, 0]
        ]

        // transpose so we can use data[x][y] like the C++ version
        var transposed = Array(repeating: Array(repeating: 0, count: height),
                               count: width)
        for y in 0..<height {
            for x in 0..<width {
                transposed[x][y] = raw[y][x]
            }
        }
        self.data = transposed
    }

    // subscript works like the C++ operator()
    subscript(x: Int, y: Int) -> Int {
        return data[x][y]
    }
}

// ------------------------------------------------------------
// MARK: - Node (stores a cell for the A* algorithm)
// ------------------------------------------------------------
struct Node: Comparable {
    var pos: Point            // cell coordinates
    var parent: Point?        // predecessor (nil for the start node)
    var g: Int                // cost from start (called “cost” in C++)
    var h: Int                // heuristic distance to goal (called “dist”)

    var f: Int {               // total estimated cost = g + h
        return g + h
    }

    // Comparable – smallest f comes first
    static func < (lhs: Node, rhs: Node) -> Bool {
        return lhs.f < rhs.f
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.pos == rhs.pos
    }
}

// ------------------------------------------------------------
// MARK: - A* implementation
// ------------------------------------------------------------
final class AStar {
    // eight neighbour offsets (same order as the C++ array)
    private let neighbours: [Point] = [
        Point(-1, -1), Point( 1, -1),
        Point(-1,  1), Point( 1,  1),
        Point( 0, -1), Point(-1,  0),
        Point( 0,  1), Point( 1,  0)
    ]

    private var map: GridMap!
    private var start: Point!
    private var goal: Point!

    private var open: [Node] = []      // frontier
    private var closed: [Node] = []    // already processed

    // ----------------------------------------------------------------
    // Heuristic – squared Euclidean distance (identical to the C++ version)
    // ----------------------------------------------------------------
    private func heuristic(_ p: Point) -> Int {
        let dx = goal.x - p.x
        let dy = goal.y - p.y
        return dx * dx + dy * dy
    }

    // ----------------------------------------------------------------
    // Returns true if a node with a *better* (smaller) f‑value already
    // exists for the same point in either the open or closed list.
    // ----------------------------------------------------------------
    private func isBetterNodeAlready(at point: Point, withF f: Int) -> Bool {
        if let n = closed.first(where: { $0.pos == point }) {
            return n.f < f
        }
        if let n = open.first(where: { $0.pos == point }) {
            return n.f < f
        }
        return false
    }

    // ----------------------------------------------------------------
    // Expand a node: generate its neighbours and push the admissible ones
    // onto the open list.
    // ----------------------------------------------------------------
    private func expand(_ node: Node) -> Bool {
        for offset in neighbours {
            // stepCost is 1 for every direction (the C++ code kept the variable)
            let stepCost = 1
            let neighbourPos = node.pos + offset

            // Goal reached – put the final node into the closed list
            if neighbourPos == goal {
                let finalNode = Node(pos: neighbourPos,
                                     parent: node.pos,
                                     g: node.g + stepCost,
                                     h: 0)
                closed.append(finalNode)
                return true
            }

            // Bounds & obstacle check
            guard neighbourPos.x >= 0, neighbourPos.y >= 0,
                  neighbourPos.x < map.width, neighbourPos.y < map.height,
                  map[neighbourPos.x, neighbourPos.y] == 0 else {
                continue
            }

            let tentativeG = node.g + stepCost
            let h = heuristic(neighbourPos)
            let f = tentativeG + h

            // Skip if we already have a better node for this cell
            if isBetterNodeAlready(at: neighbourPos, withF: f) {
                continue
            }

            // Otherwise add the new node to the open list
            let newNode = Node(pos: neighbourPos,
                               parent: node.pos,
                               g: tentativeG,
                               h: h)
            open.append(newNode)
        }
        return false
    }

    // ----------------------------------------------------------------
    // Public entry point – exactly the same semantics as the C++ `search`
    // ----------------------------------------------------------------
    func search(start: Point, goal: Point, on map: GridMap) -> Bool {
        // reset everything
        self.map = map
        self.start = start
        self.goal = goal
        open.removeAll()
        closed.removeAll()

        // seed the algorithm
        let startNode = Node(pos: start,
                             parent: nil,
                             g: 0,
                             h: heuristic(start))
        open.append(startNode)

        // main loop (no priority queue – sorting a tiny array is fine)
        while !open.isEmpty {
            open.sort()                     // smallest f first
            let current = open.removeFirst()
            closed.append(current)

            if expand(current) {            // true → goal found
                return true
            }
        }
        return false                         // no path exists
    }

    // ----------------------------------------------------------------
    // Rebuild the path (start → goal) and compute its total cost.
    // ----------------------------------------------------------------
    func reconstructPath() -> (path: [Point], cost: Int) {
        guard let last = closed.last else { return ([], 0) }

        var path: [Point] = [goal]               // goal was already added
        var parent = last.parent

        // walk backwards through the closed list following parent pointers
        for node in closed.reversed() {
            if node.pos == parent {
                path.append(node.pos)
                parent = node.parent
                if node.pos == start { break }
            }
        }
        path.append(start)

        // reverse to obtain start → goal order
        let ordered = path.reversed()
        // the original C++ code adds 1 to the cost when reporting it
        let totalCost = last.g + 1
        return (Array(ordered), totalCost)
    }
}

// ------------------------------------------------------------
// MARK: - Demo (mirrors the original `main()`)
// ------------------------------------------------------------
func demo() {
    let map = GridMap()
    let start = Point(0, 0)          // default C++ constructor = (0,0)
    let goal  = Point(7, 7)

    let astar = AStar()
    guard astar.search(start: start, goal: goal, on: map) else {
        print("No path found")
        return
    }

    let (path, cost) = astar.reconstructPath()

    // ---- pretty‑print the board (identical visual output) ----
    for y in -1...9 {
        var line = ""
        for x in -1...9 {
            if x < 0 || y < 0 || x > 7 || y > 7 || map[x, y] == 1 {
                // full‑block character – same visual as C++ char(0xdb)
                line.append("\u{2588}")
            } else {
                if path.contains(Point(x, y)) {
                    line.append("x")
                } else {
                    line.append(".")
                }
            }
        }
        print(line)
    }

    // ---- report the cost and the coordinate list ----
    print("\nPath cost \(cost): ", terminator: "")
    for p in path {
        print("(\(p.x),\(p.y)) ", terminator: "")
    }
    print("\n")
}

// Run the demo
demo()
