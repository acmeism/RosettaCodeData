class Square {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    ==(other) { _x == other.x && _y == other.y }
}

var board = List.filled(8 * 8, null)
for (i in 0...board.count) board[i] = Square.new((i/8).floor + 1, i%8 + 1)
var axisMoves = [1, 2, -1, -2]

var allPairs = Fn.new { |a|
    var pairs = []
    for (i in a) {
        for (j in a) pairs.add([i, j])
    }
    return pairs
}

var knightMoves = Fn.new { |s|
    var moves = allPairs.call(axisMoves).where { |p| p[0].abs != p[1].abs }
    var onBoard = Fn.new { |s| board.any { |i| i == s } }
    return moves.map { |p| Square.new(s.x + p[0], s.y + p[1]) }.where(onBoard)
}

var knightTour // recursive
knightTour = Fn.new { |moves|
    var findMoves = Fn.new { |s|
        return knightMoves.call(s).where { |m| !moves.any { |m2| m2 == m } }.toList
    }
    var fm = findMoves.call(moves[-1])
    if (fm.isEmpty) return moves
    var lowest = findMoves.call(fm[0]).count
    var lowestIndex = 0
    for (i in 1...fm.count) {
        var count = findMoves.call(fm[i]).count
        if (count < lowest) {
            lowest = count
            lowestIndex = i
        }
    }
    var newSquare = fm[lowestIndex]
    return knightTour.call(moves + [newSquare])
}

var knightTourFrom = Fn.new { |start| knightTour.call([start]) }

var col = 0
for (p in knightTourFrom.call(Square.new(1, 1))) {
    System.write("%(p.x),%(p.y)")
    System.write((col == 7) ? "\n" : "  ")
    col = (col + 1) % 8
}
