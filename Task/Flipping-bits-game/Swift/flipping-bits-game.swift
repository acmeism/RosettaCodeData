import Foundation

struct Board: Equatable, CustomStringConvertible {
    let size: Int
    private var tiles: [Bool]

    init(size: Int) {
        self.size = size
        tiles = Array(count: size * size, repeatedValue: false)
    }

    subscript(x: Int, y: Int) -> Bool {
        get {
            return tiles[y * size + x]
        }
        set {
            tiles[y * size + x] = newValue
        }
    }

    mutating func randomize() {
        for i in 0..<tiles.count {
            tiles[i] = Bool(random() % 2)
        }
    }

    mutating func flipRow(row: Int) {
        for i in 0..<size {
            self[row, i] = !self[row, i]
        }
    }

    mutating func flipColumn(column: Int) {
        for i in 0..<size {
            self[i, column] = !self[i, column]
        }
    }

    var description: String {
        var desc = "\n\ta\tb\tc\n"
        for i in 0..<size {
            desc += "\(i+1):\t"
            for j in 0..<size {
                desc += "\(Int(self[i, j]))\t"
            }
            desc += "\n"
        }

        return desc
    }
}

func ==(lhs: Board, rhs: Board) -> Bool {
    return lhs.tiles == rhs.tiles
}

class FlippingGame: CustomStringConvertible {

    var board: Board
    var target: Board
    var solved: Bool { return board == target }

    init(boardSize: Int) {
        target = Board(size: 3)
        board = Board(size: 3)
        generateTarget()
    }

    func generateTarget() {
        target.randomize()
        board = target
        let size = board.size
        while solved {
            for _ in 0..<size + (random() % size + 1) {
                if random() % 2 == 0 {
                    board.flipColumn(random() % size)
                }
                else {
                    board.flipRow(random() % size)
                }
            }
        }
    }

    func getMove() -> Bool {
        print(self)
        print("Flip what? ", terminator: "")

        guard
            let move = readLine(stripNewline: true)
            where move.characters.count == 1
            else { return false }

        var moveValid = true

        if let row = Int(move) {
            board.flipRow(row - 1)
        }
        else if let column = move.lowercaseString.utf8.first where column < 100 && column > 96  {
            board.flipColumn(numericCast(column) - 97)
        }
        else {
            moveValid = false
        }

        return moveValid
    }

    var description: String {
        var str = ""
        print("Target: \n \(target)", toStream: &str)
        print("Board: \n \(board)", toStream: &str)

        return str
    }
}

func playGame(game: FlippingGame) -> String {
    game.generateTarget()
    var numMoves = 0
    while !game.solved {
        numMoves++
        print("Move #\(numMoves)")
        while !game.getMove() {}
    }
    print("You win!")
    print("Number of moves: \(numMoves)")
    print("\n\nPlay Again? ", terminator: "")

    return readLine(stripNewline: true)!.lowercaseString
}

let game = FlippingGame(boardSize: 3)
repeat { } while playGame(game) == "y"
