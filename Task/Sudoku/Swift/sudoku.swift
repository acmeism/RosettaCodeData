import Foundation

typealias SodukuPuzzle = [[Int]]

class Soduku {
    let mBoardSize:Int!
    let mBoxSize:Int!
    var mBoard:SodukuPuzzle!
    var mRowSubset:[[Bool]]!
    var mColSubset:[[Bool]]!
    var mBoxSubset:[[Bool]]!

    init(board:SodukuPuzzle) {
        mBoard = board
        mBoardSize = board.count
        mBoxSize = Int(sqrt(Double(mBoardSize)))
        mRowSubset = [[Bool]](count: mBoardSize, repeatedValue: [Bool](count: mBoardSize, repeatedValue: false))
        mColSubset = [[Bool]](count: mBoardSize, repeatedValue: [Bool](count: mBoardSize, repeatedValue: false))
        mBoxSubset = [[Bool]](count: mBoardSize, repeatedValue: [Bool](count: mBoardSize, repeatedValue: false))
        initSubsets()
    }

    func computeBoxNo(i:Int, _ j:Int) -> Int {
        let boxRow = i / mBoxSize
        let boxCol = j / mBoxSize

        return boxRow * mBoxSize + boxCol
    }

    func initSubsets() {
        for i in 0..<mBoard.count {
            for j in 0..<mBoard.count {
                let value = mBoard[i][j]

                if value != 0 {
                    setSubsetValue(i, j, value, true);
                }
            }
        }
    }

    func isValid(i:Int, _ j:Int, var _ val:Int) -> Bool {
        val--
        let isPresent = mRowSubset[i][val] || mColSubset[j][val] || mBoxSubset[computeBoxNo(i, j)][val]
        return !isPresent
    }

    func printBoard() {
        for i in 0..<mBoardSize {
            if i % mBoxSize == 0 {
                println(" -----------------------")
            }

            for j in 0..<mBoardSize {
                if j % mBoxSize == 0 {
                    print("| ")
                }

                print(mBoard[i][j] != 0 ? String(mBoard[i][j]) : " ")
                print(" ")
            }

            println("|")
        }

        println(" -----------------------")
    }

    func setSubsetValue(i:Int, _ j:Int, _ value:Int, _ present:Bool) {
        mRowSubset[i][value - 1] = present
        mColSubset[j][value - 1] = present
        mBoxSubset[computeBoxNo(i, j)][value - 1] = present
    }

    func solve() {
        solve(0, 0)
    }

    func solve(var i:Int, var _ j:Int) -> Bool {
        if i == mBoardSize {
            i = 0
            j++
            if j == mBoardSize {
                return true
            }
        }

        if mBoard[i][j] != 0 {
            return solve(i + 1, j)
        }

        for value in 1...mBoardSize {
            if isValid(i, j, value) {
                mBoard[i][j] = value
                setSubsetValue(i, j, value, true)

                if solve(i + 1, j) {
                    return true
                }

                setSubsetValue(i, j, value, false)
            }
        }

        mBoard[i][j] = 0
        return false
    }
}

let board = [
    [4, 0, 0, 0, 0, 0, 0, 6, 0],
    [5, 0, 0, 0, 8, 0, 9, 0, 0],
    [3, 0, 0, 0, 0, 1, 0, 0, 0],

    [0, 2, 0, 7, 0, 0, 0, 0, 1],
    [0, 9, 0, 0, 0, 0, 0, 4, 0],
    [8, 0, 0, 0, 0, 3, 0, 5, 0],
    [0, 0, 0, 2, 0, 0, 0, 0, 7],
    [0, 0, 6, 0, 5, 0, 0, 0, 8],
    [0, 1, 0, 0, 0, 0, 0, 0, 6]
]

let puzzle = Soduku(board: board)
puzzle.solve()
puzzle.printBoard()
