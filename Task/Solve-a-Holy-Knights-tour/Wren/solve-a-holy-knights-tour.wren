import "./fmt" for Fmt

var moves = [ [-1, -2], [1, -2], [-1, 2], [1, 2], [-2, -1], [-2, 1], [2, -1], [2, 1] ]

var board1 =
    " xxx    " +
    " x xx   " +
    " xxxxxxx" +
    "xxx  x x" +
    "x x  xxx" +
    "sxxxxxx " +
    "  xx x  " +
    "   xxx  "

var board2 =
    ".....s.x....." +
    ".....x.x....." +
    "....xxxxx...." +
    ".....xxx....." +
    "..x..x.x..x.." +
    "xxxxx...xxxxx" +
    "..xx.....xx.." +
    "xxxxx...xxxxx" +
    "..x..x.x..x.." +
    ".....xxx....." +
    "....xxxxx...." +
    ".....x.x....." +
    ".....x.x....."

var solve // recursive
solve = Fn.new { |pz, sz, sx, sy, idx, cnt|
    if (idx > cnt) return true
    for (i in 0...moves.count) {
        var x = sx + moves[i][0]
        var y = sy + moves[i][1]
        if ((x >= 0 && x < sz) && (y >= 0 && y < sz) && pz[x][y] == 0) {
            pz[x][y] = idx
            if (solve.call(pz, sz, x, y, idx + 1, cnt)) return true
            pz[x][y] = 0
        }
    }
    return false
}

var findSolution = Fn.new { |b, sz|
    var pz = List.filled(sz, null)
    for (i in 0...sz) pz[i] = List.filled(sz, -1)
    var x = 0
    var y = 0
    var idx = 0
    var cnt = 0
    for (j in 0...sz) {
        for (i in 0...sz) {
            if (b[idx] == "x") {
                pz[i][j] = 0
                cnt = cnt + 1
            } else if (b[idx] == "s") {
                pz[i][j] = 1
                cnt = cnt + 1
                x = i
                y = j
            }
            idx = idx + 1
        }
    }

    if (solve.call(pz, sz, x, y, 2, cnt)) {
        for (j in 0...sz) {
            for (i in 0...sz) {
                if (pz[i][j] != -1) {
                    Fmt.write("$02d  ", pz[i][j])
                } else {
                    System.write("--  ")
                }
            }
            System.print()
        }
    } else {
        System.print("Cannot solve this puzzle!")
   }
}

findSolution.call(board1,  8)
System.print()
findSolution.call(board2, 13)
