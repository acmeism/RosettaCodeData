import "random" for Random
import "/dynamic" for Tuple, Enum, Struct

var N_CARDS = 4
var SOLVE_GOAL = 24
var MAX_DIGIT = 9

var Frac = Tuple.create("Frac", ["num", "den"])

var OpType = Enum.create("OpType", ["NUM", "ADD", "SUB", "MUL", "DIV"])

var Expr = Struct.create("Expr", ["op", "left", "right", "value"])

var showExpr // recursive function
showExpr = Fn.new { |e, prec, isRight|
    if (!e) return
    if (e.op == OpType.NUM) {
        System.write(e.value)
        return
    }
    var op = (e.op == OpType.ADD) ? " + " :
             (e.op == OpType.SUB) ? " - " :
             (e.op == OpType.MUL) ? " x " :
             (e.op == OpType.DIV) ? " / " : e.op
    if ((e.op == prec && isRight) || e.op < prec) System.write("(")
    showExpr.call(e.left, e.op, false)
    System.write(op)
    showExpr.call(e.right, e.op, true)
    if ((e.op == prec && isRight) || e.op < prec) System.write(")")
}

var evalExpr // recursive function
evalExpr = Fn.new { |e|
    if (!e) return Frac.new(0, 1)
    if (e.op == OpType.NUM) return Frac.new(e.value, 1)
    var l = evalExpr.call(e.left)
    var r = evalExpr.call(e.right)
    var res = (e.op == OpType.ADD) ? Frac.new(l.num * r.den + l.den * r.num, l.den * r.den) :
              (e.op == OpType.SUB) ? Frac.new(l.num * r.den - l.den * r.num, l.den * r.den) :
              (e.op == OpType.MUL) ? Frac.new(l.num * r.num, l.den * r.den) :
              (e.op == OpType.DIV) ? Frac.new(l.num * r.den, l.den * r.num) :
               Fiber.abort("Unknown op: %(e.op)")
    return res
}

var solve // recursive function
solve = Fn.new { |ea, len|
    if (len == 1) {
        var final = evalExpr.call(ea[0])
        if (final.num == final.den * SOLVE_GOAL && final.den != 0) {
            showExpr.call(ea[0], OpType.NUM, false)
            return true
        }
    }
    var ex = List.filled(N_CARDS, null)
    for (i in 0...len - 1) {
        for (j in i + 1...len) ex[j - 1] = ea[j]
        var node = Expr.new(OpType.NUM, null, null, 0)
        ex[i] = node
        for (j in i + 1...len) {
            node.left = ea[i]
            node.right = ea[j]
            for (k in OpType.startsFrom+1...OpType.members.count) {
                node.op = k
                if (solve.call(ex, len - 1)) return true
            }
            node.left = ea[j]
            node.right = ea[i]
            node.op = OpType.SUB
            if (solve.call(ex, len - 1)) return true
            node.op = OpType.DIV
            if (solve.call(ex, len - 1)) return true
            ex[j] = ea[j]
        }
        ex[i] = ea[i]
    }
    return false
}

var solve24 = Fn.new { |n|
    var l = List.filled(N_CARDS, null)
    for (i in 0...N_CARDS) l[i] = Expr.new(OpType.NUM, null, null, n[i])
    return solve.call(l, N_CARDS)
}

var r = Random.new()
var n = List.filled(N_CARDS, 0)
for (j in 0..9) {
    for (i in 0...N_CARDS) {
        n[i] = 1 + r.int(MAX_DIGIT)
        System.write(" %(n[i])")
    }
    System.write(":  ")
    System.print(solve24.call(n) ? "" : "No solution")
}
