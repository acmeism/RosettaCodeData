// version 1.1.3

import java.util.Random

const val N_CARDS = 4
const val SOLVE_GOAL = 24
const val MAX_DIGIT = 9

class Frac(val num: Int, val den: Int)

enum class OpType { NUM, ADD, SUB, MUL, DIV }

class Expr(
    var op:    OpType = OpType.NUM,
    var left:  Expr?  = null,
    var right: Expr?  = null,
    var value: Int    = 0
)

fun showExpr(e: Expr?, prec: OpType, isRight: Boolean) {
    if (e == null) return
    val op = when (e.op) {
        OpType.NUM -> { print(e.value); return }
        OpType.ADD -> " + "
        OpType.SUB -> " - "
        OpType.MUL -> " x "
        OpType.DIV -> " / "
    }

    if ((e.op == prec && isRight) || e.op < prec) print("(")
    showExpr(e.left, e.op, false)
    print(op)
    showExpr(e.right, e.op, true)
    if ((e.op == prec && isRight) || e.op < prec) print(")")
}

fun evalExpr(e: Expr?): Frac {
    if (e == null) return Frac(0, 1)
    if (e.op == OpType.NUM) return Frac(e.value, 1)
    val l = evalExpr(e.left)
    val r = evalExpr(e.right)
    return when (e.op) {
        OpType.ADD -> Frac(l.num * r.den + l.den * r.num, l.den * r.den)
        OpType.SUB -> Frac(l.num * r.den - l.den * r.num, l.den * r.den)
        OpType.MUL -> Frac(l.num * r.num, l.den * r.den)
        OpType.DIV -> Frac(l.num * r.den, l.den * r.num)
        else       -> throw IllegalArgumentException("Unknown op: ${e.op}")
    }
}

fun solve(ea: Array<Expr?>, len: Int): Boolean {
    if (len == 1) {
        val final = evalExpr(ea[0])
        if (final.num == final.den * SOLVE_GOAL && final.den != 0) {
            showExpr(ea[0], OpType.NUM, false)
            return true
        }
    }

    val ex = arrayOfNulls<Expr>(N_CARDS)
    for (i in 0 until len - 1) {
        for (j in i + 1 until len) ex[j - 1] = ea[j]
        val node = Expr()
        ex[i] = node
        for (j in i + 1 until len) {
            node.left = ea[i]
            node.right = ea[j]
            for (k in OpType.values().drop(1)) {
                node.op = k
                if (solve(ex, len - 1)) return true
            }
            node.left = ea[j]
            node.right = ea[i]
            node.op = OpType.SUB
            if (solve(ex, len - 1)) return true
            node.op = OpType.DIV
            if (solve(ex, len - 1)) return true
            ex[j] = ea[j]
        }
        ex[i] = ea[i]
    }
    return false
}

fun solve24(n: IntArray) =
    solve (Array(N_CARDS) { Expr(value = n[it]) }, N_CARDS)

fun main(args: Array<String>) {
    val r = Random()
    val n = IntArray(N_CARDS)
    for (j in 0..9) {
        for (i in 0 until N_CARDS) {
            n[i] = 1 + r.nextInt(MAX_DIGIT)
            print(" ${n[i]}")
        }
        print(":  ")
        println(if (solve24(n)) "" else "No solution")
    }
}
