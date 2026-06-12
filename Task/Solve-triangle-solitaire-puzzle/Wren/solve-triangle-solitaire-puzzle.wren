import "./fmt" for Conv, Fmt

var board = List.filled(16, true)
board[0] = false

var jumpMoves = [
    [ ],
    [ [ 2,  4], [ 3,  6] ],
    [ [ 4,  7], [ 5,  9] ],
    [ [ 5,  8], [ 6, 10] ],
    [ [ 2,  1], [ 5,  6], [ 7, 11], [ 8, 13] ],
    [ [ 8, 12], [ 9, 14] ],
    [ [ 3,  1], [ 5,  4], [ 9, 13], [10, 15] ],
    [ [ 4,  2], [ 8,  9] ],
    [ [ 5,  3], [ 9, 10] ],
    [ [ 5,  2], [ 8,  7] ],
    [ [ 9,  8] ],
    [ [12, 13] ],
    [ [ 8,  5], [13, 14] ],
    [ [ 8,  4], [ 9,  6], [12, 11], [14, 15] ],
    [ [ 9,  5], [13, 12] ],
    [ [10,  6], [14, 13] ]
]

var solutions = []

var drawBoard = Fn.new {
    var pegs = List.filled(16, "-")
    for (i in 1..15) if (board[i]) pegs[i] = Conv.Itoa(i, 16)
    Fmt.print("       $s", pegs[1])
    Fmt.print("      $s $s", pegs[2], pegs[3])
    Fmt.print("     $s $s $s", pegs[4], pegs[5], pegs[6])
    Fmt.print("    $s $s $s $s", pegs[7], pegs[8], pegs[9], pegs[10])
    Fmt.print("   $s $s $s $s $s", pegs[11], pegs[12], pegs[13], pegs[14], pegs[15])
}

var solved = Fn.new { board.count { |peg| peg } == 1 }  // just one peg left

var solve // recursive so need to pre-declare
solve = Fn.new {
    if (solved.call()) return
    for (peg in 1..15) {
        if (board[peg]) {
            for (ol in jumpMoves[peg]) {
                var over = ol[0]
                var land = ol[1]
                if (board[over] && !board[land]) {
                    var saveBoard = board.toList
                    board[peg]  = false
                    board[over] = false
                    board[land] = true
                    solutions.add([peg, over, land])
                    solve.call()
                    if (solved.call()) return // otherwise back-track
                    board = saveBoard
                    solutions.removeAt(-1)
                }
            }
        }
    }
}

var emptyStart = 1
board[emptyStart] = false
solve.call()
board = List.filled(16, true)
board[0] = false
board[emptyStart] = false
drawBoard.call()
Fmt.print("Starting with peg $X removed\n", emptyStart)
for (sol in solutions) {
    var peg =  sol[0]
    var over = sol[1]
    var land = sol[2]
    board[peg]  = false
    board[over] = false
    board[land] = true
    drawBoard.call()
    Fmt.print("Peg $X jumped over $X to land on $X\n", peg, over, land)
}
