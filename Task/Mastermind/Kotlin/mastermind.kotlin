// version 1.2.51

import java.util.Random

val rand = Random()

class Mastermind {
    private val codeLen: Int
    private val colorsCnt: Int
    private var guessCnt = 0
    private val repeatClr: Boolean

    private val colors: String
    private var combo = ""

    private val guesses = mutableListOf<CharArray>()
    private val results = mutableListOf<CharArray>()

    constructor(codeLen: Int, colorsCnt: Int, guessCnt: Int, repeatClr: Boolean) {
        val color = "ABCDEFGHIJKLMNOPQRST"
        this.codeLen = codeLen.coerceIn(4, 10)
        var cl = colorsCnt
        if (!repeatClr && cl < this.codeLen) cl = this.codeLen
        this.colorsCnt = cl.coerceIn(2, 20)
        this.guessCnt = guessCnt.coerceIn(7, 20)
        this.repeatClr = repeatClr
        this.colors = color.take(this.colorsCnt)
    }

    fun play() {
        var win = false
        combo = getCombo()
        while (guessCnt != 0) {
            showBoard()
            if (checkInput(getInput())) {
                win = true
                break
            }
            guessCnt--
        }
        println("\n\n--------------------------------")
        if (win) {
            println("Very well done!\nYou found the code: $combo")
        }
        else {
            println("I am sorry, you couldn't make it!\nThe code was: $combo")
        }
        println("--------------------------------\n")
    }

    private fun showBoard() {
        for (x in 0 until guesses.size) {
            println("\n--------------------------------")
            print("${x + 1}: ")
            for (y in guesses[x]) print("$y ")
            print(" :  ")
            for (y in results[x]) print("$y ")
            val z = codeLen - results[x].size
            if (z > 0) print("- ".repeat(z))
        }
        println("\n")
    }

    private fun getInput(): String {
        while (true) {
            print("Enter your guess ($colors): ")
            val a = readLine()!!.toUpperCase().take(codeLen)
            if (a.all { it in colors } ) return a
        }
    }

    private fun checkInput(a: String): Boolean {
        guesses.add(a.toCharArray())
        var black = 0
        var white = 0
        val gmatch = BooleanArray(codeLen)
        val cmatch = BooleanArray(codeLen)
        for (i in 0 until codeLen) {
            if (a[i] == combo[i]) {
                gmatch[i] = true
                cmatch[i] = true
                black++
            }
        }
        for (i in 0 until codeLen) {
            if (gmatch[i]) continue
            for (j in 0 until codeLen) {
                if (i == j || cmatch[j]) continue
                if (a[i] == combo[j]) {
                    cmatch[j] = true
                    white++
                    break
                }
            }
        }
        val r = mutableListOf<Char>()
        r.addAll("X".repeat(black).toList())
        r.addAll("O".repeat(white).toList())
        results.add(r.toCharArray())
        return black == codeLen
    }

    private fun getCombo(): String {
        val c =  StringBuilder()
        val clr = StringBuilder(colors)
        for (s in 0 until codeLen) {
            val z = rand.nextInt(clr.length)
            c.append(clr[z])
            if (!repeatClr) clr.deleteCharAt(z)
        }
        return c.toString()
    }
}

fun main(args: Array<String>) {
    val m = Mastermind(4, 8, 12, false)
    m.play()
}
