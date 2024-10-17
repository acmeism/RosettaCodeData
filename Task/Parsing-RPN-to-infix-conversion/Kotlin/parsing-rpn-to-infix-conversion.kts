// version 1.2.0

import java.util.Stack

class Expression(var ex: String, val op: String = "", val prec: Int = 3) {

    constructor(e1: String, e2: String, o: String) :
        this("$e1 $o $e2", o, OPS.indexOf(o) / 2)

    override fun toString() = ex

    companion object {
        const val OPS = "-+/*^"
    }
}

fun postfixToInfix(postfix: String): String {
    val expr = Stack<Expression>()
    val rx = Regex("""\s+""")
    for (token in postfix.split(rx)) {
        val c = token[0]
        val idx = Expression.OPS.indexOf(c)
        if (idx != -1 && token.length == 1) {
            val r = expr.pop()
            val l = expr.pop()
            val opPrec = idx / 2
            if (l.prec < opPrec || (l.prec == opPrec && c == '^')) {
                l.ex = "(${l.ex})"
            }
            if (r.prec < opPrec || (r.prec == opPrec && c != '^')) {
                r.ex = "(${r.ex})"
            }
            expr.push(Expression(l.ex, r.ex, token))
        }
        else {
            expr.push(Expression(token))
        }
        println("$token -> $expr")
    }
    return expr.peek().ex
}

fun main(args: Array<String>) {
    val es = listOf(
        "3 4 2 * 1 5 - 2 3 ^ ^ / +",
        "1 2 + 3 4 + ^ 5 6 + ^"
    )
    for (e in es) {
        println("Postfix : $e")
        println("Infix : ${postfixToInfix(e)}\n")
    }
}
