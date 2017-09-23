import Foundation

extension Array {
    mutating func swap(_ index1:Int, _ index2:Int) {
        let temp = self[index1]
        self[index1] = self[index2]
        self[index2] = temp
    }

    mutating func shuffle() {
        for _ in 0..<self.count {
            let index1 = Int(arc4random()) % self.count
            let index2 = Int(arc4random()) % self.count
            self.swap(index1, index2)
        }
    }
}

enum Direction:Int {
    case north = 1
    case south = 2
    case east = 4
    case west = 8

    static var allDirections:[Direction] {
        return [Direction.north, Direction.south, Direction.east, Direction.west]
    }

    var opposite:Direction {
        switch self {
        case .north:
            return .south
        case .south:
            return .north
        case .east:
            return .west
        case .west:
            return .east
        }
    }

    var diff:(Int, Int) {
        switch self {
        case .north:
            return (0, -1)
        case .south:
            return (0, 1)
        case .east:
            return (1, 0)
        case .west:
            return (-1, 0)
        }
    }

    var char:String {
        switch self {
        case .north:
            return "N"
        case .south:
            return "S"
        case .east:
            return "E"
        case .west:
            return "W"
        }
    }

}

class MazeGenerator {
    let x:Int
    let y:Int
    var maze:[[Int]]

    init(_ x:Int, _ y:Int) {
        self.x  = x
        self.y = y
        let column = [Int](repeating: 0, count: y)
        self.maze = [[Int]](repeating: column, count: x)
        generateMaze(0, 0)
    }

    private func generateMaze(_ cx:Int, _ cy:Int) {
        var directions = Direction.allDirections
        directions.shuffle()
        for direction in directions {
            let (dx, dy) = direction.diff
            let nx = cx + dx
            let ny = cy + dy
            if inBounds(nx, ny) && maze[nx][ny] == 0 {
                maze[cx][cy] |= direction.rawValue
                maze[nx][ny] |= direction.opposite.rawValue
                generateMaze(nx, ny)
            }
        }
    }

    private func inBounds(_ testX:Int, _ testY:Int) -> Bool {
        return inBounds(value:testX, upper:self.x) && inBounds(value:testY, upper:self.y)
    }

    private func inBounds(value:Int, upper:Int) -> Bool {
        return (value >= 0) && (value < upper)
    }

    func display() {
        let cellWidth = 3
        for j in 0..<y {
            // Draw top edge
            var topEdge = ""
            for i in 0..<x {
                topEdge += "+"
                topEdge += String(repeating: (maze[i][j] & Direction.north.rawValue) == 0 ? "-" : " ", count: cellWidth)
            }
            topEdge += "+"
            print(topEdge)

            // Draw left edge
            var leftEdge = ""
            for i in 0..<x {
                leftEdge += (maze[i][j] & Direction.west.rawValue) == 0 ? "|" : " "
                leftEdge += String(repeating: " ", count: cellWidth)
            }
            leftEdge += "|"
            print(leftEdge)
        }

        // Draw bottom edge
        var bottomEdge = ""
        for _ in 0..<x {
            bottomEdge += "+"
            bottomEdge += String(repeating: "-", count: cellWidth)
        }
        bottomEdge += "+"
        print(bottomEdge)
    }

    func displayInts() {
        for j in 0..<y {
            var line = ""
            for i in 0..<x {
                line += String(maze[i][j]) + "\t"
            }
            print(line)
        }
    }

    func displayDirections() {
        for j in 0..<y {
            var line = ""
            for i in 0..<x {
                line += getDirectionsAsString(maze[i][j]) + "\t"
            }
            print(line)
        }
    }

    private func getDirectionsAsString(_ value:Int) -> String {
        var line = ""
        for direction in Direction.allDirections {
            if (value & direction.rawValue) != 0 {
                line += direction.char
            }
        }
        return line
    }
}


let x = 20
let y = 10
let maze = MazeGenerator(x, y)
maze.display()
