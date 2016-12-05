import Foundation

class Direction {
    var vect:(Int, Int, Int)
    var bit:Int {
        let (bit, dx, dy) = vect
        return bit
    }

    var dx:Int {
        let (bit, dx, dy) = vect
        return dx
    }

    var dy:Int {
        let (bit, dx, dy) = vect
        return dy
    }

    var opposite:Direction {
        switch (vect) {
        case (1, 0, -1):
            return Direction(bit: 2, dx: 0, dy: 1)
        case (2, 0, 1):
            return Direction(bit: 1, dx: 0, dy: -1)
        case (4, 1, 0):
            return Direction(bit: 8, dx: -1, dy: 0)
        case (8, -1, 0):
            return Direction(bit: 4, dx: 1, dy: 0)
        default:
            return Direction(bit: 0, dx: 0, dy: 0)
        }
    }

    init(bit:Int, dx:Int, dy:Int) {
        self.vect = (bit, dx, dy)
    }
}

let N = Direction(bit: 1, dx: 0, dy: -1)
let S = Direction(bit: 2, dx: 0, dy: 1)
let E = Direction(bit: 4, dx: 1, dy: 0)
let W = Direction(bit: 8, dx: -1, dy: 0)

class MazeGenerator {
    let x:Int!
    let y:Int!
    var maze:[[Int]]!

    init(_ x:Int, _ y:Int) {
        self.x  = x
        self.y = y
        var col = [Int](count: y, repeatedValue: 0)
        self.maze = [[Int]](count: x, repeatedValue: col)
        generateMaze(0, 0)
    }

    func display() {
        for i in 0..<y {
            // Draw top edge
            for j in 0..<x {
                print((maze[j][i] & 1) == 0 ? "+---" : "+   ")
            }
            println("+")

            // Draw left edge
            for j in 0..<x {
                print((maze[j][i] & 8) == 0 ? "|   " : "    ")
            }
            println("|")
        }

        // Draw bottom edge
        for j in 0..<x {
            print("+---")
        }
        println("+")
    }

    func generateMaze(cx:Int, _ cy:Int) {
        var dirs = [N, S, E, W] as NSMutableArray
        for i in 0..<dirs.count {
            let x1 = Int(arc4random()) % dirs.count
            let x2 = Int(arc4random()) % dirs.count
            dirs.exchangeObjectAtIndex(x1, withObjectAtIndex: x2)
        }

        for dir in dirs {
            var dir = dir as Direction
            let nx = cx + dir.dx
            let ny = cy + dir.dy
            if (between(nx, self.x) && between(ny, self.y) && (maze[nx][ny] == 0)) {
                    maze[cx][cy] |= dir.bit
                    maze[nx][ny] |= dir.opposite.bit
                    generateMaze(nx, ny)
            }

        }
    }

    func between(v:Int, _ upper:Int) -> Bool {
        return (v >= 0) && (v < upper)
    }
}

let x = 10
let y = 10
let maze = MazeGenerator(x, y)
maze.display()
