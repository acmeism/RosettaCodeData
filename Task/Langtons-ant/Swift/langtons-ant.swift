import Foundation

let WIDTH = 100
let HEIGHT = 100

struct Point {
    var x:Int
    var y:Int
}

enum Direction: Int {
    case North = 0, East, West, South
}

class Langton {
    let leftTurn = [Direction.West, Direction.North, Direction.South, Direction.East]
    let rightTurn = [Direction.East, Direction.South, Direction.North, Direction.West]
    let xInc = [0, 1,-1, 0]
    let yInc = [-1, 0, 0, 1]
    var isBlack:[[Bool]]
    var origin:Point
    var antPosition = Point(x:0, y:0)
    var outOfBounds = false
    var antDirection = Direction.East

    init(width:Int, height:Int) {
        self.origin = Point(x:width / 2, y:height / 2)
        self.isBlack = Array(count: width, repeatedValue: Array(count: height, repeatedValue: false))
    }

    func moveAnt() {
        self.antPosition.x += xInc[self.antDirection.rawValue]
        self.antPosition.y += yInc[self.antDirection.rawValue]
    }

    func step() -> Point {
        if self.outOfBounds {
            println("Ant tried to move while out of bounds.")
            exit(0)
        }

        var ptCur = Point(x:self.antPosition.x + self.origin.x, y:self.antPosition.y + self.origin.y)
        let black = self.isBlack[ptCur.x][ptCur.y]
        let direction = self.antDirection.rawValue

        self.antDirection = (black ? self.leftTurn : self.rightTurn)[direction]

        self.isBlack[ptCur.x][ptCur.y] = !self.isBlack[ptCur.x][ptCur.y]

        self.moveAnt()
        ptCur = Point(x:self.antPosition.x + self.origin.x, y:self.antPosition.y + self.origin.y)
        self.outOfBounds =
            ptCur.x < 0 ||
            ptCur.x >= self.isBlack.count ||
            ptCur.y < 0 ||
            ptCur.y >= self.isBlack[0].count

        return self.antPosition
    }
}


let ant = Langton(width: WIDTH, height: HEIGHT)
while !ant.outOfBounds {
    ant.step()
}

for row in 0 ..< WIDTH {
    for col in 0 ..< HEIGHT {
        print(ant.isBlack[col][row] ? "#" : " ")
    }
    println()
}
