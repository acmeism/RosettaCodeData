import "./dynamic" for Enum, Tuple

var Piece = Enum.create("Piece", ["empty", "black", "white"])

var Pos = Tuple.create("Pos", ["x", "y"])

var isAttacking = Fn.new { |q, pos|
    return q.x == pos.x || q.y == pos.y || (q.x - pos.x).abs == (q.y - pos.y).abs
}

var place // recursive
place = Fn.new { |m, n, blackQueens, whiteQueens|
    if (m == 0) return true
    var placingBlack = true
    for (i in 0...n) {
        for (j in 0...n) {
            var pos = Pos.new(i, j)
            var inner = false
            for (queen in blackQueens) {
                var equalPos = queen.x == pos.x && queen.y == pos.y
                if (equalPos || !placingBlack && isAttacking.call(queen, pos)) {
                    inner = true
                    break
                }
            }
            if (!inner) {
                for (queen in whiteQueens) {
                    var equalPos = queen.x == pos.x && queen.y == pos.y
                    if (equalPos || placingBlack && isAttacking.call(queen, pos)) {
                        inner = true
                        break
                    }
                }
                if (!inner) {
                    if (placingBlack) {
                        blackQueens.add(pos)
                        placingBlack = false
                    } else {
                        whiteQueens.add(pos)
                        if (place.call(m-1, n, blackQueens, whiteQueens)) return true
                        blackQueens.removeAt(-1)
                        whiteQueens.removeAt(-1)
                        placingBlack = true
                    }
                }
            }
        }
    }
    if (!placingBlack) blackQueens.removeAt(-1)
    return false
}

var printBoard = Fn.new { |n, blackQueens, whiteQueens|
    var board = List.filled(n * n, 0)
    for (queen in blackQueens) board[queen.x * n + queen.y] = Piece.black
    for (queen in whiteQueens) board[queen.x * n + queen.y] = Piece.white
    var i = 0
    for (b in board) {
        if (i != 0 && i%n == 0) System.print()
        if (b == Piece.black) {
            System.write("B ")
        } else if (b == Piece.white) {
            System.write("W ")
        } else {
            var j = (i/n).floor
            var k = i - j*n
            if (j%2 == k%2) {
                System.write("• ")
            } else {
                System.write("◦ ")
            }
        }
        i = i + 1
    }
    System.print("\n")
}

var nms = [
    Pos.new(2, 1), Pos.new(3, 1), Pos.new(3, 2), Pos.new(4, 1), Pos.new(4, 2), Pos.new(4, 3),
    Pos.new(5, 1), Pos.new(5, 2), Pos.new(5, 3), Pos.new(5, 4), Pos.new(5, 5),
    Pos.new(6, 1), Pos.new(6, 2), Pos.new(6, 3), Pos.new(6, 4), Pos.new(6, 5), Pos.new(6, 6),
    Pos.new(7, 1), Pos.new(7, 2), Pos.new(7, 3), Pos.new(7, 4), Pos.new(7, 5), Pos.new(7, 6), Pos.new(7, 7)
]
for (p in nms) {
    System.print("%(p.y) black and %(p.y) white queens on a %(p.x) x %(p.x) board:")
    var blackQueens = []
    var whiteQueens = []
    if (place.call(p.y, p.x, blackQueens, whiteQueens)) {
        printBoard.call(p.x, blackQueens, whiteQueens)
    } else {
        System.print("No solution exists.\n")
    }
}
