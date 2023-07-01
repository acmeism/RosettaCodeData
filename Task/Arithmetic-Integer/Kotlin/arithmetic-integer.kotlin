import kotlin.math.pow // not an operator but in the standard library

fun main() {
    val r = Regex("""-?[0-9]+\s+-?[0-9]+""")
    print("Enter two integers separated by space(s): ")
    val input: String = readLine()!!.trim()
    val index = input.lastIndexOf(' ')
    val a = input.substring(0, index).trimEnd().toLong()
    val b = input.substring(index + 1).toLong()
    println("$a + $b = ${a + b}")
    println("$a - $b = ${a - b}")
    println("$a * $b = ${a * b}")
    println("$a / $b = ${a / b}")  // rounds towards zero
    println("$a % $b = ${a % b}")  // if non-zero, matches sign of first operand
    println("$a ^ $b = ${a.toDouble().pow(b.toDouble())}")
}
}
