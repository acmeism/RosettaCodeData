import java.util.Random
import java.util.Scanner
import java.util.Stack

internal object Game24 {
    fun run() {
        val r = Random()
        val digits = IntArray(4).map { r.nextInt(9) + 1 }
        println("Make 24 using these digits: $digits")
        print("> ")

        val s = Stack<Float>()
        var total = 0L
        val cin = Scanner(System.`in`)
        for (c in cin.nextLine()) {
            when (c) {
                in '0'..'9' -> {
                    val d = c - '0'
                    total += (1 shl (d * 5)).toLong()
                    s += d.toFloat()
                }
                else ->
                    if ("+/-*".indexOf(c) != -1) {
                        s += c.applyOperator(s.pop(), s.pop())
                    }
            }
        }

        when {
            tally(digits) != total ->
                print("Not the same digits. ")
            s.peek().compareTo(target) == 0 ->
                println("Correct!")
            else ->
                print("Not correct.")
        }
    }

    private fun Char.applyOperator(a: Float, b: Float) = when (this) {
        '+' -> a + b
        '-' -> b - a
        '*' -> a * b
        '/' -> b / a
        else -> Float.NaN
    }

    private fun tally(a: List<Int>): Long = a.reduce({ t, i -> t + (1 shl (i * 5)) }).toLong()

    private val target = 24
}

fun main(args: Array<String>) = Game24.run()
