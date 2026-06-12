import "./ioutil" for Input, Output
import "./str" for Str

var blackPawn   = " \u265f  "
var whitePawn   = " \u2659  "
var emptySquare = "    "

var drawBoard = Fn.new { |boardData|
    var bgBlack    = "\e[48;5;237m"
    var bgWhite    = "\e[48;5;245m"
    var clearToEol = "\e[0m\e[K\n"
    var board = [
        "1 ", bgBlack, boardData[0][0], bgWhite, boardData[0][1], bgBlack, boardData[0][2], clearToEol,
        "2 ", bgWhite, boardData[1][0], bgBlack, boardData[1][1], bgWhite, boardData[1][2], clearToEol,
        "3 ", bgBlack, boardData[2][0], bgWhite, boardData[2][1], bgBlack, boardData[2][2], clearToEol,
        "   A   B   C\n"
    ]
    System.print()
    Output.fwrite(board.join())
}

var getMovementDirection = Fn.new { |color|
    var direction = -1
    if (color == blackPawn) {
        direction = 1
    } else if (color != whitePawn) {
        Fiber.abort("Invalid piece color")
    }
    return direction
}

var getOtherColor = Fn.new { |color|
    if (color == blackPawn) {
        return whitePawn
    } else if (color == whitePawn) {
        return blackPawn
    } else {
        Fiber.abort("Invalid piece color")
    }
}

var getAllowedMoves = Fn.new { |boardData, row, col|
    var allowedMoves = []
    if (boardData[row][col] == emptySquare) return allowedMoves
    var color = boardData[row][col]
    var otherColor = getOtherColor.call(color)
    var direction = getMovementDirection.call(color)
    if (row + direction < 0 || row + direction > 2) return allowedMoves
    if (boardData[row + direction][col] == emptySquare) allowedMoves.add("f")
    if (col > 0 && boardData[row + direction][col - 1] == otherColor) allowedMoves.add("dl")
    if (col < 2 && boardData[row + direction][col + 1] == otherColor) allowedMoves.add("dr")
    return allowedMoves
}

var getHumanMove = Fn.new { |boardData, color|
    // The direction the pawns may move depends on the colour; assuming that white starts at the bottom.
    var direction = getMovementDirection.call(color)
    var validInputs = {
        "a1": [0,0], "b1": [0,1], "c1": [0,2],
        "a2": [1,0], "b2": [1,1], "c2": [1,2],
        "a3": [2,0], "b3": [2,1], "c3": [2,2]
    }
    var keys = validInputs.keys.toList
    while (true) {
        var piecePosn = Str.lower(Input.text("What %(color) do you want to move? : ", 2, 2))
        if (!keys.contains(piecePosn)) {
            System.print("LOL that's not a valid position! Try again.")
            continue
        }
        var rc = validInputs[piecePosn]
        var row = rc[0]
        var col = rc[1]
        var piece = boardData[row][col]
        if (piece == emptySquare) {
            System.print("What are you trying to pull, there's no piece in that space!")
            continue
        }
        if (piece != color) {
            System.print("LOL that's not your piece, try again!")
            continue
        }
        var allowedMoves = getAllowedMoves.call(boardData, row, col)

        if (allowedMoves.count == 0) {
            System.print("LOL nice try. That piece has no valid moves.")
            continue
        }
        var move = allowedMoves.toList[0]
        if (allowedMoves.count > 1) {
            var options = allowedMoves.join(", ")
            move = Str.lower(Input.text("What move do you want to make [%(options)]? : ", 1, 2))
            if (!allowedMoves.contains(move)) {
                System.print("LOL that move is not allowed. Try again.")
                continue
            }
        }
        if (move == "f") {
            boardData[row + direction][col] = boardData[row][col]
        } else if (move == "dl") {
            boardData[row + direction][col - 1] = boardData[row][col]
        } else if (move == "dr") {
            boardData[row + direction][col + 1] = boardData[row][col]
        }
        boardData[row][col] = emptySquare
        return boardData
    }
}

var isGameOver = Fn.new { |boardData|
    if (boardData[0][0] == whitePawn || boardData[0][1] == whitePawn || boardData[0][2] == whitePawn) {
        return whitePawn
    }
    if (boardData[2][0] == blackPawn || boardData[2][1] == blackPawn || boardData[2][2] == blackPawn) {
        return blackPawn
    }
    var whiteCount = 0
    var blackCount = 0
    var blackAllowedMoves = []
    var whiteAllowedMoves = []
    for (i in 0..2) {
        for (j in 0..2) {
            var moves = getAllowedMoves.call(boardData, i, j)
            if (boardData[i][j] == whitePawn) {
                whiteCount = whiteCount + 1
                if (moves.count > 0) whiteAllowedMoves.add([i, j, moves])
            } else if (boardData[i][j] == blackPawn) {
                blackCount = blackCount + 1
                if (moves.count > 0) blackAllowedMoves.add([i, j, moves])
            }
        }
    }
    if (whiteCount == 0 || whiteAllowedMoves.count == 0) return blackPawn
    if (blackCount == 0 || blackAllowedMoves.count == 0) return whitePawn
    return "LOL NOPE"
}

var playGame = Fn.new { |blackMove, whiteMove|
    var boardData = [
        [blackPawn, blackPawn, blackPawn],
        [emptySquare, emptySquare, emptySquare],
        [whitePawn, whitePawn, whitePawn]
    ]
    var lastPlayer = blackPawn
    var nextPlayer = whitePawn
    while (isGameOver.call(boardData) == "LOL NOPE") {
        drawBoard.call(boardData)
        if (nextPlayer == blackPawn) {
            boardData = blackMove.call(boardData, nextPlayer)
        } else {
            boardData = whiteMove.call(boardData, nextPlayer)
        }
        var temp = lastPlayer
        lastPlayer = nextPlayer
        nextPlayer = temp
    }
    drawBoard.call(boardData)
    var winner = isGameOver.call(boardData)
    System.print("Congratulations %(winner)!")
}

playGame.call(getHumanMove, getHumanMove)
