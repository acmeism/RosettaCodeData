import "./fmt" for Fmt

var board
var diag1
var diag2
var diag1Lookup
var diag2Lookup
var n
var minCount
var layout

var isAttacked = Fn.new { |piece, row, col|
    if (piece == "Q") {
        for (i in 0...n) {
            if (board[i][col] || board[row][i]) return true
        }
        if (diag1Lookup[diag1[row][col]] ||
            diag2Lookup[diag2[row][col]]) return true
    } else if (piece == "B") {
        if (diag1Lookup[diag1[row][col]] ||
            diag2Lookup[diag2[row][col]]) return true
    } else { // piece == "K"
        if (board[row][col]) return true
        if (row + 2 < n  && col - 1 >= 0 && board[row + 2][col - 1]) return true
        if (row - 2 >= 0 && col - 1 >= 0 && board[row - 2][col - 1]) return true
        if (row + 2 < n  && col + 1 < n  && board[row + 2][col + 1]) return true
        if (row - 2 >= 0 && col + 1 < n  && board[row - 2][col + 1]) return true
        if (row + 1 < n  && col + 2 < n  && board[row + 1][col + 2]) return true
        if (row - 1 >= 0 && col + 2 < n  && board[row - 1][col + 2]) return true
        if (row + 1 < n  && col - 2 >= 0 && board[row + 1][col - 2]) return true
        if (row - 1 >= 0 && col - 2 >= 0 && board[row - 1][col - 2]) return true
    }
    return false
}

var attacks = Fn.new { |piece, row, col, trow, tcol|
    if (piece == "Q") {
        return row == trow || col == tcol || (row-trow).abs == (col-tcol).abs
    } else if (piece == "B") {
        return (row-trow).abs == (col-tcol).abs
    } else { // piece == "K"
        var rd = (trow - row).abs
        var cd = (tcol - col).abs
        return (rd == 1 && cd == 2) || (rd == 2 && cd == 1)
    }
}

var storeLayout = Fn.new { |piece|
    var sb = ""
    for (row in board) {
        for (cell in row) sb = sb + (cell ? piece + " " : ". ")
        sb = sb + "\n"
    }
    layout = sb
}

var placePiece // recursive function
placePiece = Fn.new { |piece, countSoFar, maxCount|
    if (countSoFar >= minCount) return
    var allAttacked = true
    var ti = 0
    var tj = 0
    for (i in 0...n) {
        for (j in 0...n) {
            if (!isAttacked.call(piece, i, j)) {
                allAttacked = false
                ti = i
                tj = j
                break
            }
        }
        if (!allAttacked) break
    }
    if (allAttacked) {
        minCount = countSoFar
        storeLayout.call(piece)
        return
    }
    if (countSoFar <= maxCount) {
        var si = (piece == "K") ? (ti-2).max(0) : ti
        var sj = (piece == "K") ? (tj-2).max(0) : tj
        for (i in si...n) {
            for (j in sj...n) {
                if (!isAttacked.call(piece, i, j)) {
                    if ((i == ti && j == tj) || attacks.call(piece, i, j, ti, tj)) {
                        board[i][j] = true
                        if (piece != "K") {
                            diag1Lookup[diag1[i][j]] = true
                            diag2Lookup[diag2[i][j]] = true
                        }
                        placePiece.call(piece, countSoFar + 1, maxCount)
                        board[i][j] = false
                        if (piece != "K") {
                            diag1Lookup[diag1[i][j]] = false
                            diag2Lookup[diag2[i][j]] = false
                        }
                    }
                }
            }
        }
    }
}

var start = System.clock
var pieces = ["Q", "B", "K"]
var limits = {"Q": 10, "B": 10, "K": 10}
var names  = {"Q": "Queens", "B": "Bishops", "K": "Knights"}
for (piece in pieces) {
    System.print(names[piece])
    System.print("=======\n")
    n = 1
    while (true) {
        board = List.filled(n, null)
        for (i in 0...n) board[i] = List.filled(n, false)
        if (piece != "K") {
            diag1 = List.filled(n, null)
            for (i in 0...n) {
                diag1[i] = List.filled(n, 0)
                for (j in 0...n) diag1[i][j] = i + j
            }
            diag2 = List.filled(n, null)
            for (i in 0...n) {
                diag2[i] = List.filled(n, 0)
                for (j in 0...n) diag2[i][j] = i - j + n - 1
            }
            diag1Lookup = List.filled(2*n-1, false)
            diag2Lookup = List.filled(2*n-1, false)
        }
        minCount = Num.maxSafeInteger
        layout = ""
        for (maxCount in 1..n*n) {
            placePiece.call(piece, 0, maxCount)
            if (minCount <= n*n) break
        }
        Fmt.print("$2d x $-2d : $d", n, n, minCount)
        if (n == limits[piece]) {
            Fmt.print("\n$s on a $d x $d board:", names[piece], n, n)
            System.print("\n" + layout)
            break
        }
        n = n + 1
    }
}
System.print("Took %(System.clock - start) seconds.")
