import "./ioutil" for Input
import "./ansi" for Screen

var EMPTY = 0
var WHITE = 1
var BLACK = 2

Input.quit = "0"

var board = List.filled(25, 0) // [0] not used

// Mills (16 lines of 3)
var mills = [
    [ 1,  2,  3], [ 4,  5,  6], [ 7,  8,  9], [10, 11, 12],
    [13, 14, 15], [16, 17, 18], [19, 20, 21], [22, 23, 24],
    [ 1, 10, 22], [ 4, 11, 19], [ 7, 12, 16], [ 2,  5,  8],
    [17, 20, 23], [ 9, 13, 18], [ 6, 14, 21], [ 3, 15, 24]
]

// Adjacencies (24 lines of 4, 0 = no neighbor)
var adj = [
    [ 2, 10,  0,  0],  // 1
    [ 1,  3,  5,  0],  // 2
    [ 2, 15,  0,  0],  // 3
    [ 5, 11,  0,  0],  // 4
    [ 2,  4,  6,  8],  // 5
    [ 5, 14,  0,  0],  // 6
    [ 8, 12,  0,  0],  // 7
    [ 5,  7,  9,  0],  // 8
    [ 8, 13,  0,  0],  // 9
    [ 1, 11, 22,  0],  // 10
    [ 4, 10, 12, 19],  // 11
    [ 7, 11, 16,  0],  // 12
    [ 9, 14, 18,  0],  // 13
    [ 6, 13, 15, 21],  // 14
    [ 3, 14, 24,  0],  // 15
    [12, 17,  0,  0],  // 16
    [16, 18, 20,  0],  // 17
    [13, 17,  0,  0],  // 18
    [11, 20,  0,  0],  // 19
    [17, 19, 21, 23],  // 20
    [14, 20,  0,  0],  // 21
    [10, 23,  0,  0],  // 22
    [20, 22, 24,  0],  // 23
    [15, 23,  0,  0]   // 24
]

// --------- Utilities ------

var pieceChar = Fn.new { |v|
    return v == EMPTY ? "." :
           v == WHITE ? "W" :
           v == BLACK ? "B" : "?"
}

var printBoard = Fn.new {
    System.print(" -=  Wren Mill Game  =- ")
    System.print()
    System.print("Positions (1-24) & scoreboard")
    System.print("   1-----------2-----------3")
    System.print("   |           |           |")
    System.print("   |   4-------5-------6   |")
    System.print("   |   |       |       |   |")
    System.print("   |   |   7---8---9   |   |")
    System.print("  10--11--12       13--14--15")
    System.print("   |   |   16--17--18  |   |")
    System.print("   |   |       |       |   |")
    System.print("   |   19------20------21  |")
    System.print("   |           |           |")
    System.print("   22----------23----------24")
    System.print()
    System.print("State:")

    // Line 1
    System.write("  ")
    System.write(pieceChar.call(board[1]))
    System.write("-----------")
    System.write(pieceChar.call(board[2]))
    System.write("-----------")
    System.print(pieceChar.call(board[3]))

    System.print("  |           |           |")

    // Line 2
    System.write("  |   ")
    System.write(pieceChar.call(board[4]))
    System.write("-------")
    System.write(pieceChar.call(board[5]))
    System.write("-------")
    System.write(pieceChar.call(board[6]))
    System.print("   |")

    System.print("  |   |       |       |   |")

    // Line 3
    System.write("  |   |   ")
    System.write(pieceChar.call(board[7]))
    System.write("---")
    System.write(pieceChar.call(board[8]))
    System.write("---")
    System.write(pieceChar.call(board[9]))
    System.print("   |   |")

    // Central line
    System.write("  ")
    System.write(pieceChar.call(board[10]))
    System.write("---")
    System.write(pieceChar.call(board[11]))
    System.write("---")
    System.write(pieceChar.call(board[12]))
    System.write("       ")
    System.write(pieceChar.call(board[13]))
    System.write("---")
    System.write(pieceChar.call(board[14]))
    System.write("---")
    System.print(pieceChar.call(board[15]))

    // Line 4
    System.write("  |   |   ")
    System.write(pieceChar.call(board[16]))
    System.write("---")
    System.write(pieceChar.call(board[17]))
    System.write("---")
    System.write(pieceChar.call(board[18]))
    System.print("   |   |")

    System.print("  |   |       |       |   |")

    // Line 5
    System.write("  |   ")
    System.write(pieceChar.call(board[19]))
    System.write("-------")
    System.write(pieceChar.call(board[20]))
    System.write("-------")
    System.write(pieceChar.call(board[21]))
    System.print("   |")

    System.print("  |           |           |")

    // Line 6
    System.write("  ")
    System.write(pieceChar.call(board[22]))
    System.write("-----------")
    System.write(pieceChar.call(board[23]))
    System.write("-----------")
    System.print(pieceChar.call(board[24]))
    System.print()
    System.print("Enter 0 to quit")
    System.print()
}

var getIntInRange = Fn.new { |prompt, lo, hi|
    var i = Input.integer(prompt, lo, hi)
    if (i == "0") {
        System.print("You have quit!")
        Fiber.suspend()
    }
    return i
}

var isMill = Fn.new { |posic, player|
    for (i in 1..16) {
        var c = 0
        for (j in 1..3) {
            if (mills[i - 1][j - 1] == posic) {
                for (k in 1..3) {
                    if (board[mills[i - 1][k - 1]] == player) {
                        c = c + 1
                    }
                }
                if (c == 3) return true
            }
        }
    }
    return false
}

var countPieces = Fn.new { |player|
    var c = 0
    for (i in 1..24) {
        if (board[i] == player) c = c + 1
    }
    return c
}

var hasAnyNonMillPiece = Fn.new { |player|
    for (i in 1..24) {
        if (board[i] == player) {
            if (!isMill.call(i, player)) return true
        }
    }
    return false
}

var capturePiece = Fn.new { |enemy|
    var posic
    var allowMill = !hasAnyNonMillPiece.call(enemy)
    // true if all enemy pieces are in mills.
    while (true) {
        posic = Input.integer("Choose enemy piece to capture (1-24): ", 1, 24)
        if (posic == "0") {
            System.print("You have quit!")
            Fiber.suspend()
        }
        if (board[posic] != enemy) continue
        if (!allowMill && isMill.call(posic, enemy)) {
            System.print("You can't capture a piece in a mill while others are available.")
            continue
        }
        break
    }
    board[posic] = EMPTY
}

var hasMoves = Fn.new { |player|
    var pc = countPieces.call(player)

    // If player has 3 pieces, can fly anywhere.
    if (pc == 3) {
        for (i in 1..24) {
            if (board[i] == player) {
                for (j in 1..24) {
                    if (board[j] == EMPTY) return true
                }
            }
        }
        return false
    }

    // Normal move: to adjacent empty positions.
    for (i in 1..24) {
        if (board[i] == player) {
            for (j in 1..4) {
                if (adj[i - 1][j - 1] != 0) {
                    if (board[adj[i - 1][j - 1]] == EMPTY) return true
                }
            }
        }
    }
    return false
}

// ----------------- Placing phase -----------------
var placePiece = Fn.new { |player|
    var posic
    while (true) {
        posic = getIntInRange.call("Player " + (player == WHITE ? "White": "Black") +
        " places piece (1-24): ", 1, 24)
        if (board[posic] != EMPTY) {
            System.print("That position is already occupied.")
        } else {
            break
        }
    }
    board[posic] = player

    if (isMill.call(posic, player)) {
        System.print("Mill! You may capture an enemy piece.")
        capturePiece.call(3 - player)
    }
}

// ----------------- Moving phase -----------------
var movePiece = Fn.new { |player|
    var pc = countPieces.call(player)
    var canFly = (pc == 3)
    var fromPos
    var toPos

    // Choose piece to move.
    while (true) {
        fromPos = getIntInRange.call("Player " + (player == WHITE ? "White" : "Black") +
        " moves from (1-24): ", 1, 24)
        if (board[fromPos] != player) {
            System.print("You have no piece there.")
        } else {
            break
        }
    }

    // Choose destination.
    while (true) {
        toPos = getIntInRange.call("To empty position (1-24): ", 1, 24)
        if (board[toPos] !=  EMPTY) {
            System.print("That square is not empty.")
            continue
        }

        if (canFly) {
            break   // can fly anywhere
        } else {
            // Must be adjacent.
            var ok = false
            for (j in 1..4) {
                if (adj[fromPos - 1][j - 1] == toPos) {
                    ok = true
                    break
                }
            }
            if (!ok) {
                System.print("Invalid move: destination is not adjacent.")
            } else {
                break
            }
        }
    }

    board[fromPos] = EMPTY
    board[toPos]   = player

    if (isMill.call(toPos, player)) {
        System.print("Mill! You may capture an enemy piece.")
        capturePiece.call(3 - player)
    }
}

// ----------------- Main program -----------------
var whiteInHand = 9
var blackInHand = 9
var turn = WHITE
var winner = 0

// Placing phase.
while (whiteInHand > 0 || blackInHand > 0) {
    Screen.clear()
    printBoard.call()
    if (turn == WHITE) {
        if (whiteInHand > 0) {
            System.print("Pieces to place - White:%(whiteInHand) Black:%(blackInHand)")
            placePiece.call(WHITE)
            whiteInHand = whiteInHand - 1
        }
    } else {
        if (blackInHand > 0) {
            System.print("Pieces to place - White:%(whiteInHand) Black:%(blackInHand)")
            placePiece.call(BLACK)
            blackInHand = blackInHand - 1
        }
    }
    turn = 3 - turn
}

// Moving phase.
while (true) {
    Screen.clear()
    printBoard.call()

    var whiteCount = countPieces.call(WHITE)
    var blackCount = countPieces.call(BLACK)

    if (whiteCount < 3) {
        winner = BLACK
        break
    } else if (blackCount < 3) {
        winner = WHITE
        break
    }

    if (!hasMoves.call(turn)) {
        winner = 3 - turn
        break
    }

    System.write("Turn: ")
    System.print(turn == WHITE ? "White (W)" : "Black (B)")
    System.print("Pieces on board - White:%(whiteCount) Black:%(blackCount)")
    if (countPieces.call(turn) == 3) System.print("(You can fly: only 3 pieces left.)")

    movePiece.call(turn)
    turn = 3 - turn
}

Screen.clear()
printBoard.call()
if (winner == WHITE) {
    System.print("White player wins!")
} else if (winner == BLACK) {
    System.print("Black player wins!")
} else {
    System.print("Game over.")
}
