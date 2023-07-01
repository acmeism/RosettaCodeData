import java.util.Random

fun isBalanced(s: String): Boolean {
    if (s.isEmpty()) return true
    var countLeft = 0  // number of left brackets so far unmatched
    for (c in s) {
        if (c == '[') countLeft++
        else if (countLeft > 0) countLeft--
        else return false
    }
    return countLeft == 0
}

fun main(args: Array<String>) {
    println("Checking examples in task description:")
    val brackets = arrayOf("", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]")
    for (b in brackets) {
        print(if (b != "") b else "(empty)")
        println("\t  " + if (isBalanced(b)) "OK" else "NOT OK")
    }
    println()

    println("Checking 7 random strings of brackets of length 8:")
    val r = Random()
    (1..7).forEach {
        var s = ""
        for (j in 1..8) {
            s += if (r.nextInt(2) == 0) '[' else ']'
        }
        println("$s  " + if (isBalanced(s)) "OK" else "NOT OK")
    }
}
