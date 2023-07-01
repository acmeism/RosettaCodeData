import "random" for Random
import "/fmt" for Fmt

var rand = Random.new()

var grid = List.filled(8, null)
for (i in 0..7) grid[i] = List.filled(9, ".")

var placeKings = Fn.new {
    while (true) {
        var r1 = rand.int(8)
        var c1 = rand.int(8)
        var r2 = rand.int(8)
        var c2 = rand.int(8)
        if (r1 != r2 && (r1 - r2).abs > 1 && (c1 - c2).abs > 1) {
            grid[r1][c1] = "K"
            grid[r2][c2] = "k"
            return
        }
    }
}

var placePieces = Fn.new { |pieces, isPawn|
    var numToPlace = rand.int(pieces.count)
    for (n in 0...numToPlace) {
        var r
        var c
        while (true) {
            r = rand.int(8)
            c = rand.int(8)
            if (grid[r][c] == "." && !(isPawn && (r == 7 || r == 0))) break
        }
        grid[r][c] = pieces[n]
    }
}

var toFen = Fn.new {
    var fen = ""
    var countEmpty = 0
    for (r in 0..7) {
        for (c in 0..7) {
            var ch = grid[r][c]
            Fmt.write("$2s ", ch)
            if (ch == ".") {
                countEmpty = countEmpty + 1
            } else {
                if (countEmpty > 0) {
                    fen = fen + countEmpty.toString
                    countEmpty = 0
                }
                fen = fen + ch
            }
        }
        if (countEmpty > 0) {
            fen = fen + countEmpty.toString
            countEmpty = 0
        }
        fen = fen + "/"
        System.print()
    }
    return fen + " w - - 0 1"
}

var createFen = Fn.new {
    placeKings.call()
    placePieces.call("PPPPPPPP", true)
    placePieces.call("pppppppp", true)
    placePieces.call("RNBQBNR", false)
    placePieces.call("rnbqbnr", false)
    return toFen.call()
}

System.print(createFen.call())
