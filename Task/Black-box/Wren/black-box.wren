import "random" for Random
import "./fmt" for Fmt
import "./ioutil" for Input
import "./str" for Str

var b = List.filled(100, null)  // displayed board
var h = List.filled(100, null)  // hidden atoms
var wikiGame = true             // set to false for a 'random' game
var rand = Random.new()

var hideAtoms = Fn.new {
    var placed = 0
    while (placed < 4) {
        var a = rand.int(11, 89) // 11 to 88 inclusive
        var m = a % 10
        if (m == 0 || m == 9 || h[a] == "T") continue
        h[a] = "T"
        placed = placed + 1
    }
}

var initialize = Fn.new {
    for (i in 0..99) {
        b[i] = " "
        h[i] = "F"
    }
    if (!wikiGame) {
        hideAtoms.call()
    } else {
        h[32] = "T"
        h[37] = "T"
        h[64] = "T"
        h[87] = "T"
    }
    System.print("""
    === BLACK BOX ===

    H    Hit (scores 1)
    R    Reflection (scores 1)
    1-9, Detour (scores 2)
    a-c  Detour for 10-12 (scores 2)
    G    Guess (maximum 4)
    Y    Correct guess
    N    Incorrect guess (scores 5)
    A    Unguessed atom

    Cells are numbered a0 to j9.
    Corner cells do nothing.
    Use edge cells to fire beam.
    Use middle cells to add/delete a guess.
    Game ends automatically after 4 guesses.
    Enter q to abort game at any time.
    """)
}

var drawGrid = Fn.new { |score, guesses|
    System.print("      0   1   2   3   4   5   6   7   8   9 ")
    System.print()
    System.print("        ╔═══╦═══╦═══╦═══╦═══╦═══╦═══╦═══╗")
    Fmt.lprint("a     $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s",
        [b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9]])
    System.print("    ╔═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╗")
    Fmt.lprint  ("b   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[10], b[11], b[12], b[13], b[14], b[15], b[16], b[17], b[18], b[19]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("c   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[20], b[21], b[22], b[23], b[24], b[25], b[26], b[27], b[28], b[29]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("d   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[30], b[31], b[32], b[33], b[34], b[35], b[36], b[37], b[38], b[39]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("e   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[40], b[41], b[42], b[43], b[44], b[45], b[46], b[47], b[48], b[49]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("f   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[50], b[51], b[52], b[53], b[54], b[55], b[56], b[57], b[58], b[59]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("g   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[60], b[61], b[62], b[63], b[64], b[65], b[66], b[67], b[68], b[69]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("h   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[70], b[71], b[72], b[73], b[74], b[75], b[76], b[77], b[78], b[79]])
    System.print("    ╠═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╣")
    Fmt.lprint  ("i   ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║",
        [b[80], b[81], b[82], b[83], b[84], b[85], b[86], b[87], b[88], b[89]])
    System.print("    ╚═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╬═══╝")
    Fmt.lprint  ("j     $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s ║ $s",
        [b[90], b[91], b[92], b[93], b[94], b[95], b[96], b[97], b[98], b[99]])
    System.print("        ╚═══╩═══╩═══╩═══╩═══╩═══╩═══╩═══╝")
    var status = (guesses != 4) ? "In play" : "Game over!"
    System.print("\n        Score = %(score)\tGuesses = %(guesses)\t Status = %(status)\n")
}

var atCorner = Fn.new { |ix| ix == 0 || ix == 9 || ix == 90 || ix == 99 }

var inRange  = Fn.new { |ix| ix >= 1 && ix <= 98 && ix != 9 && ix != 90 }

var atTop    = Fn.new { |ix| ix >= 1 && ix <= 8 }

var atBottom = Fn.new { |ix| ix >= 91 && ix <= 98 }

var atLeft   = Fn.new { |ix| inRange.call(ix) && ix%10 == 0 }

var atRight  = Fn.new { |ix| inRange.call(ix) && ix%10 == 9 }

var inMiddle = Fn.new { |ix|
    return inRange.call(ix) && !atTop.call(ix) && !atBottom.call(ix) &&
           !atLeft.call(ix) && !atRight.call(ix)
}

var nextCell = Fn.new {
    var ix
    while (true) {
        var sq = Str.lower(Input.text("    Choose cell : ", 1))
        if (sq.count == 1 && sq[0] == "q") {
            Fiber.abort("program aborted")
        }
        if (sq.count != 2 || !"abcdefghij".contains(sq[0]) || !"0123456789".contains(sq[1])) {
            continue
        }
        ix = (sq[0].bytes[0] - 97) * 10 + sq[1].bytes[0] - 48
        if (atCorner.call(ix)) continue
        break
    }
    System.print()
    return ix
}

var finalScore = Fn.new { |score, guesses|
    for (i in 11..88) {
        var m = i % 10
        if (m == 0 || m == 9) continue
        if (b[i] == "G" && h[i] == "T") {
            b[i] = "Y"
        } else if (b[i] == "G" && h[i] == "F") {
            b[i] = "N"
            score = score + 5
        } else if (b[i] == " " && h[i] == "T") {
            b[i] = "A"
        }
    }
    drawGrid.call(score, guesses)
}

var play = Fn.new {
    var score = 0
    var guesses = 0
    var num = "0"
    while (true) {
        var outer = false
        drawGrid.call(score, guesses)
        var ix = nextCell.call()
        if (!inMiddle.call(ix) && b[ix] != " ") continue  // already processed
        var inc
        var def
        if (atTop.call(ix)) {
            inc = 10
            def = 1
        } else if (atBottom.call(ix)) {
            inc = -10
            def = 1
        } else if (atLeft.call(ix)) {
            inc = 1
            def = 10
        } else if (atRight.call(ix)) {
            inc = -1
            def = 10
        } else {
            if (b[ix] != "G") {
                b[ix] = "G"
                guesses = guesses + 1
                if (guesses == 4) break
            } else {
                b[ix] = " "
                guesses = guesses - 1
            }
            continue
        }
        var x = ix + inc
        var first = true
        while (inMiddle.call(x)) {
            if (h[x] == "T" ) {  // hit
                b[ix] = "H"
                score = score + 1
                first = false
                outer = true
                break
            }
            if (first && (inMiddle.call(x+def) && h[x+def] == "T") ||
                (inMiddle.call(x-def) && h[x-def] == "T")) {  // reflection
                b[ix] = "R"
                score = score + 1
                first = false
                outer = true
                break
            }
            first = false
            var y = x + inc - def
            if (inMiddle.call(y) && h[y] == "T") {  // deflection
                if (inc.abs == 1) {
                    inc = 10
                    def = 1
                } else if (inc.abs == 10) {
                    inc = 1
                    def = 10
                }
            }
            y = x + inc + def
            if (inMiddle.call(y) && h[y] == "T") {  // deflection or double deflection
                if (inc.abs == 1) {
                    inc = -10
                    def = 1
                } else if (inc.abs == 10) {
                    inc = -1
                    def = 10
                }
            }
            x = x + inc
        }
        if (outer) continue
        if (num != "9") {
            num = String.fromByte(num.bytes[0] + 1)
        } else {
            num = "a"
        }
        if (b[ix] == " ") score = score + 1
        b[ix] = num
        if (inRange.call(x)) {
            if (ix == x) {
                b[ix] = "R"
            } else {
                if (b[x] == " ") score = score + 1
                b[x] = num
            }
        }
    }
    drawGrid.call(score, guesses)
    finalScore.call(score, guesses)
}

while (true) {
    initialize.call()
    play.call()
    var yn = Str.lower(Input.option("    Play again y/n : ", "ynYN"))
    if (yn == "n") return
}
