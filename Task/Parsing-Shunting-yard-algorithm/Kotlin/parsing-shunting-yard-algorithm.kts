// version 1.2.0

import java.util.Stack

/* To find out the precedence, we take the index of the
   token in the OPS string and divide by 2 (rounding down).
   This will give us: 0, 0, 1, 1, 2 */
const val OPS = "-+/*^"

fun infixToPostfix(infix: String): String {
    val sb = StringBuilder()
    val s = Stack<Int>()
    val rx = Regex("""\s""")
    for (token in infix.split(rx)) {
        if (token.isEmpty()) continue
        val c = token[0]
        val idx = OPS.indexOf(c)

        // check for operator
        if (idx != - 1) {
            if (s.isEmpty()) {
                s.push(idx)
            }
            else {
                while (!s.isEmpty()) {
                    val prec2 = s.peek() / 2
                    val prec1 = idx / 2
                    if (prec2 > prec1 || (prec2 == prec1 && c != '^')) {
                        sb.append(OPS[s.pop()]).append(' ')
                    }
                    else break
                }
                s.push(idx)
            }
        }
        else if (c == '(') {
            s.push(-2)  // -2 stands for '('
        }
        else if (c == ')') {
            // until '(' on stack, pop operators.
            while (s.peek() != -2) sb.append(OPS[s.pop()]).append(' ')
            s.pop()
        }
        else {
            sb.append(token).append(' ')
        }
    }
    while (!s.isEmpty()) sb.append(OPS[s.pop()]).append(' ')
    return sb.toString()
}

fun main(args: Array<String>) {
    val es = listOf(
        "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3",
        "( ( 1 + 2 ) ^ ( 3 + 4 ) ) ^ ( 5 + 6 )"
    )
    for (e in es) {
        println("Infix : $e")
        println("Postfix : ${infixToPostfix(e)}\n")
    }
}
