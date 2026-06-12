import "random" for Random
import "./iterate" for Stepped
import "./fmt" for Fmt
import "./ioutil" for Input
import "./str" for Str

var rand = Random.new()

var easy = 1
var hard = 4

var n = List.filled(16, 0)

var initGrid = Fn.new {
    for (i in 0..15) n[i] = i + 1
}

var rotate = Fn.new { |ix|
    var last = n[ix[3]]
    for (i in 3..1) n[ix[i]] = n[ix[i-1]]
    n[ix[0]] = last
}

var hasWon = Fn.new {
    for (i in 0...15) {
        if (n[i] != i+1) return false
    }
    return true
}

var setDiff = Fn.new { |level|
    var moves = (level == easy) ? 3 : 12
    var rc = []
    var i = 0
    while (i < moves) {
        rc.clear()
        var r = rand.int(2)
        var s = rand.int(4)
        if (r == 0) {  // rotate random row
            for (j in s*4...(s+1)*4) rc.add(j)
        } else {  // rotate random column
            for (j in Stepped.new(s...s+16, 4)) rc.add(j)
        }
        var rca = rc.toList
        rotate.call(rca)
        if (hasWon.call()) { // do it again
            i = -1
        }
        i = i + 1
    }
    System.print("Target is %(moves) moves.")
}

var drawGrid = Fn.new {
    System.print()
    System.print("     D1   D2   D3   D4")
    System.print("   ╔════╦════╦════╦════╗")
    Fmt.print   ("R1 ║ $2d ║ $2d ║ $2d ║ $2d ║ L1", n[0], n[1], n[2], n[3])
    System.print("   ╠════╬════╬════╬════╣")
    Fmt.print   ("R2 ║ $2d ║ $2d ║ $2d ║ $2d ║ L2", n[4], n[5], n[6], n[7])
    System.print("   ╠════╬════╬════╬════╣")
    Fmt.print   ("R3 ║ $2d ║ $2d ║ $2d ║ $2d ║ L3", n[8], n[9], n[10], n[11])
    System.print("   ╠════╬════╬════╬════╣")
    Fmt.print   ("R4 ║ $2d ║ $2d ║ $2d ║ $2d ║ L4", n[12], n[13], n[14], n[15])
    System.print("   ╚════╩════╩════╩════╝")
    System.print("     U1   U2   U3   U4\n")
}

initGrid.call()
var level = easy
var diff = Input.option("Enter difficulty level easy or hard E/H : ", "eEhH")
if (diff == "h" || diff == "H") level = hard
setDiff.call(level)
var ix = List.filled(4, 0)
System.print("When entering moves, you can also enter Q to quit or S to start again.")
var moves = 0
while (true) {
    drawGrid.call()
    if (hasWon.call()) {
        System.print("Congratulations, you have won the game in %(moves) moves!!")
        return
    }
    while (true) {
        System.print("Moves so far = %(moves)\n")
        var move = Str.upper(Input.text("Enter move : ", 1).trim())
        if (move == "D1" || move == "D2" || move == "D3" || move == "D4") {
            var c = move[1].bytes[0] - 49
            ix[0] = 0 + c
            ix[1] = 4 + c
            ix[2] = 8 + c
            ix[3] = 12 + c
            rotate.call(ix)
            moves = moves + 1
            break
        } else if (move == "L1" || move == "L2" || move == "L3" || move == "L4") {
            var c = move[1].bytes[0] - 49
            ix[0] = 3 + 4*c
            ix[1] = 2 + 4*c
            ix[2] = 1 + 4*c
            ix[3] = 0 + 4*c
            rotate.call(ix)
            moves = moves + 1
            break
        } else if (move == "U1" || move == "U2" || move == "U3" || move == "U4") {
            var c = move[1].bytes[0] - 49
            ix[0] = 12 + c
            ix[1] = 8 + c
            ix[2] = 4 + c
            ix[3] = 0 + c
            rotate.call(ix)
            moves = moves + 1
            break
        } else if (move == "R1" || move == "R2" || move == "R3" || move == "R4") {
            var c = move[1].bytes[0] - 49
            ix[0] = 0 + 4*c
            ix[1] = 1 + 4*c
            ix[2] = 2 + 4*c
            ix[3] = 3 + 4*c
            rotate.call(ix)
            moves = moves + 1
            break
        } else if (move == "Q") {
            return
        } else if (move == "S") {
            initGrid.call()
            setDiff.call(level)
            moves = 0
            break
        } else {
            System.print("Invalid move, try again.")
        }
    }
}
