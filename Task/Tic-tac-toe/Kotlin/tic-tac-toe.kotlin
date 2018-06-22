// version 1.1.51

import java.util.Random

val r = Random()
val b = Array(3) { IntArray(3) }  // board -> 0: blank; -1: computer; 1: human

var bestI = 0
var bestJ = 0

fun checkWinner(): Int {
    for (i in 0..2) {
        if (b[i][0] != 0 && b[i][1] == b[i][0] && b[i][2] == b[i][0]) return b[i][0]
        if (b[0][i] != 0 && b[1][i] == b[0][i] && b[2][i] == b[0][i]) return b[0][i]
    }
    if (b[1][1] == 0) return 0
    if (b[1][1] == b[0][0] && b[2][2] == b[0][0]) return b[0][0]
    if (b[1][1] == b[2][0] && b[0][2] == b[1][1]) return b[1][1]
    return 0
}

fun showBoard() {
    val t = "X O"
    for (i in 0..2) {
        for (j in 0..2) print("${t[b[i][j] + 1]} ")
        println()
    }
    println("-----")
}

fun testMove(value: Int, depth: Int): Int {
    var best = -1
    var changed = 0
    var score = checkWinner()
    if (score != 0) return if (score == value) 1 else -1
    for (i in 0..2) {
        for (j in 0..2) {
            if (b[i][j] != 0) continue
            b[i][j] = value
            changed = value
            score = -testMove(-value, depth + 1)
            b[i][j] = 0
            if (score <= best) continue
            if (depth == 0) {
                bestI = i
                bestJ = j
            }
            best = score
        }
    }
    return if (changed != 0) best else 0
}

fun game(user: Boolean): String {
    var u = user
    for (i in 0..2) b[i].fill(0)
    print("Board postions are numbered so:\n1 2 3\n4 5 6\n7 8 9\n")
    print("You have O, I have X.\n\n")

    for (k in 0..8) {
        while (u) {
            var move: Int?
            do {
                print("Your move: ")
                move = readLine()!!.toIntOrNull()
            }
            while (move != null && move !in 1..9)
            move = move!! - 1
            val i = move / 3
            val j = move % 3
            if (b[i][j] != 0) continue
            b[i][j] = 1
            break
        }
        if (!u) {
            if (k == 0) { // randomize if computer opens, less boring
                bestI = r.nextInt(Int.MAX_VALUE) % 3
                bestJ = r.nextInt(Int.MAX_VALUE) % 3
            }
            else testMove(-1, 0)
            b[bestI][bestJ] = -1
            val myMove = bestI * 3 + bestJ + 1
            println("My move: $myMove")
        }
        showBoard()
        val win = checkWinner()
        if (win != 0) return (if (win == 1) "You win" else "I win") + ".\n\n"
        u = !u
    }
    return "A draw.\n\n"
}

fun main(args: Array<String>) {
    var user = false
    while (true) {
        user = !user
        print(game(user))
        var yn: String
        do {
            print("Play again y/n: ")
            yn = readLine()!!.toLowerCase()
        }
        while (yn != "y" && yn != "n")
        if (yn != "y") return
        println()
    }
}
