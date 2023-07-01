// version 1.1.3

import java.util.Random

val rand = Random()
val target = Array(3) { IntArray(3) { rand.nextInt(2) } }
val board  = Array(3) { IntArray(3) }

fun flipRow(r: Int) {
    for (c in 0..2) board[r][c] = if (board[r][c] == 0) 1 else 0
}

fun flipCol(c: Int) {
    for (r in 0..2) board[r][c] = if (board[r][c] == 0) 1 else 0
}

/** starting from the target we make 9 random row or column flips */
fun initBoard() {
    for (i in 0..2) {
        for (j in 0..2) board[i][j] = target[i][j]
    }
    repeat(9) {
        val rc = rand.nextInt(2)
        if (rc == 0)
            flipRow(rand.nextInt(3))
        else
            flipCol(rand.nextInt(3))
    }
}

fun printBoard(label: String, isTarget: Boolean = false) {
    val a = if (isTarget) target else board
    println("$label:")
    println("  | a b c")
    println("---------")
    for (r in 0..2) {
        print("${r + 1} |")
        for (c in 0..2) print(" ${a[r][c]}")
        println()
    }
    println()
}

fun gameOver(): Boolean {
    for (r in 0..2) {
        for (c in 0..2) if (board[r][c] != target[r][c]) return false
    }
    return true
}

fun main(args: Array<String>) {
     // initialize board and ensure it differs from the target i.e. game not already over!
    do {
        initBoard()
    }
    while(gameOver())

    printBoard("TARGET", true)
    printBoard("OPENING BOARD")
    var flips = 0

    do {
        var isRow = true
        var n = -1
        do {
            print("Enter row number or column letter to be flipped: ")
            val input = readLine()!!
            val ch = if (input.isNotEmpty()) input[0].toLowerCase() else '0'
            if (ch !in "123abc") {
                println("Must be 1, 2, 3, a, b or c")
                continue
            }
            if (ch in '1'..'3') {
                n = ch.toInt() - 49
            }
            else {
                isRow = false
                n = ch.toInt() - 97
            }
        }
        while (n == -1)

        flips++
        if (isRow) flipRow(n) else flipCol(n)
        val plural = if (flips == 1) "" else "S"
        printBoard("\nBOARD AFTER $flips FLIP$plural")
    }
    while (!gameOver())

    val plural = if (flips == 1) "" else "s"
    println("You've succeeded in $flips flip$plural")
}
