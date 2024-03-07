import "./seq" for Stack
import "./pattern" for Pattern

/* To find out the precedence, we take the index of the
   token in the OPS string and divide by 2 (rounding down).
   This will give us: 0, 0, 1, 1, 2 */
var ops = "-+/*^"

var infixToPostfix = Fn.new { |infix|
    var sb = ""
    var s = Stack.new()
    var p = Pattern.new("+1/s")
    for (token in p.splitAll(infix)) {
        var c = token[0]
        var idx = ops.indexOf(c)

        // check for operator
        if (idx != - 1) {
            if (s.isEmpty) {
                s.push(idx)
            } else {
                while (!s.isEmpty) {
                    var prec2 = (s.peek()/2).floor
                    var prec1 = (idx/2).floor
                    if (prec2 > prec1 || (prec2 == prec1 && c != "^")) {
                        sb = sb + ops[s.pop()] + " "
                    } else break
                }
                s.push(idx)
            }
        } else if (c == "(") {
            s.push(-2)  // -2 stands for "("
        } else if (c == ")") {
            // until "(" on stack, pop operators.
            while (s.peek() != -2) sb = sb + ops[s.pop()] + " "
            s.pop()
        } else {
            sb = sb + token + " "
        }
    }
    while (!s.isEmpty) sb = sb + ops[s.pop()] + " "
    return sb
}

var es = [
    "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3",
    "( ( 1 + 2 ) ^ ( 3 + 4 ) ) ^ ( 5 + 6 )"
]
for (e in es) {
    System.print("Infix   : %(e)")
    System.print("Postfix : %(infixToPostfix.call(e))\n")
}
