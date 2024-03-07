import "./seq" for Stack
import "./pattern" for Pattern

class Expression {
    static ops { "-+/*^" }

    construct new(ex, op, prec) {
        _ex = ex
        _op = op
        _prec = prec
    }

    static build(e1, e2, o) { new("%(e1) %(o) %(e2)", o, (ops.indexOf(o)/2).floor) }

    ex { _ex }
    ex=(other) { _ex = other }
    prec { _prec }

    toString { _ex }
}

var postfixToInfix = Fn.new { |postfix|
    var expr = Stack.new()
    var p = Pattern.new("+1/s")
    for (token in p.splitAll(postfix)) {
        var c = token[0]
        var idx = Expression.ops.indexOf(c)
        if (idx != -1 && token.count == 1) {
            var r = expr.pop()
            var l = expr.pop()
            var opPrec = (idx/2).floor
            if (l.prec < opPrec || (l.prec == opPrec && c == "^")) {
                l.ex = "(%(l.ex))"
            }
            if (r.prec < opPrec || (r.prec == opPrec && c != "^")) {
                r.ex = "(%(r.ex))"
            }
            expr.push(Expression.build(l.ex, r.ex, token))
        } else {
            expr.push(Expression.new(token, "", 3))
        }
        System.print("%(token) -> %(expr)")
    }
    return expr.peek().ex
}

var es = [
    "3 4 2 * 1 5 - 2 3 ^ ^ / +",
    "1 2 + 3 4 + ^ 5 6 + ^"
]
for (e in es) {
    System.print("Postfix : %(e)")
    System.print("Infix : %(postfixToInfix.call(e))\n")
}
