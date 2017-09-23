// version 1.1.2

fun rpnCalculate(expr: String) {
    if (expr.isEmpty()) throw IllegalArgumentException("Expresssion cannot be empty")
    println("For expression = $expr\n")
    println("Token           Action             Stack")
    val tokens = expr.split(' ').filter { it != "" }
    val stack = mutableListOf<Double>()
    for (token in tokens) {
        val d = token.toDoubleOrNull()
        if (d != null) {
            stack.add(d)
            println(" $d   Push num onto top of stack  $stack")
        }
        else if ((token.length > 1) || (token !in "+-*/^")) {
            throw IllegalArgumentException("$token is not a valid token")
        }
        else if (stack.size < 2) {
            throw IllegalArgumentException("Stack contains too few operands")
        }
        else {
            val d1 = stack.removeAt(stack.lastIndex)
            val d2 = stack.removeAt(stack.lastIndex)
            stack.add(when (token) {
                "+"  -> d2 + d1
                "-"  -> d2 - d1
                "*"  -> d2 * d1
                "/"  -> d2 / d1
                else -> Math.pow(d2, d1)
            })
            println(" $token     Apply op to top of stack    $stack")
        }
    }
    println("\nThe final value is ${stack[0]}")
}

fun main(args: Array<String>) {
    val expr = "3 4 2 * 1 5 - 2 3 ^ ^ / +"
    rpnCalculate(expr)
}
