// version 1.2.10

import kotlin.math.abs

abstract class MatrixNG {
    var cfn = 0
    var thisTerm = 0
    var haveTerm = false

    abstract fun consumeTerm()
    abstract fun consumeTerm(n: Int)
    abstract fun needTerm(): Boolean
}

class NG4(
    var a1: Int, var a: Int, var b1: Int,  var b: Int
) : MatrixNG() {

    private var t = 0

    override fun needTerm(): Boolean {
        if (b1 == 0 && b == 0) return false
        if (b1 == 0 || b == 0) return true
        thisTerm = a / b
        if (thisTerm ==  a1 / b1) {
            t = a;   a = b;   b = t - b  * thisTerm
            t = a1; a1 = b1; b1 = t - b1 * thisTerm
            haveTerm = true
            return false
        }
        return true
    }

    override fun consumeTerm() {
        a = a1
        b = b1
    }

    override fun consumeTerm(n: Int) {
        t = a; a = a1; a1 = t + a1 * n
        t = b; b = b1; b1 = t + b1 * n
    }
}

class NG8(
    var a12: Int, var a1: Int, var a2: Int, var a: Int,
    var b12: Int, var b1: Int, var b2: Int, var b: Int
) : MatrixNG() {

    private var t = 0
    private var ab = 0.0
    private var a1b1 = 0.0
    private var a2b2 = 0.0
    private var a12b12 = 0.0

    fun chooseCFN() = if (abs(a1b1 - ab) > abs(a2b2-ab)) 0 else 1

    override fun needTerm(): Boolean {
        if (b1 == 0 && b == 0 && b2 == 0 && b12 == 0) return false
        if (b == 0) {
            cfn = if (b2 == 0) 0 else 1
            return true
        }
        else ab = a.toDouble() / b

        if (b2 == 0) {
            cfn = 1
            return true
        }
        else a2b2 = a2.toDouble() / b2

        if (b1 == 0) {
            cfn = 0
            return true
        }
        else a1b1 = a1.toDouble() / b1

        if (b12 == 0) {
            cfn = chooseCFN()
            return true
        }
        else a12b12 = a12.toDouble() / b12

        thisTerm = ab.toInt()
        if (thisTerm == a1b1.toInt() && thisTerm == a2b2.toInt() &&
            thisTerm == a12b12.toInt()) {
            t = a;     a = b;     b = t -   b * thisTerm
            t = a1;   a1 = b1;   b1 = t -  b1 * thisTerm
            t = a2;   a2 = b2;   b2 = t -  b2 * thisTerm
            t = a12; a12 = b12; b12 = t - b12 * thisTerm
            haveTerm = true
            return false
        }
        cfn = chooseCFN()
        return true
    }

    override fun consumeTerm() {
        if (cfn == 0) {
            a = a1; a2 = a12
            b = b1; b2 = b12
        }
        else {
            a = a2; a1 = a12
            b = b2; b1 = b12
        }
    }

    override fun consumeTerm(n: Int) {
        if (cfn == 0) {
            t = a;   a = a1;   a1 = t +  a1 * n
            t = a2; a2 = a12; a12 = t + a12 * n
            t = b;   b = b1;   b1 = t +  b1 * n
            t = b2; b2 = b12; b12 = t + b12 * n
        }
        else {
            t = a;   a = a2;   a2 = t +  a2 * n
            t = a1; a1 = a12; a12 = t + a12 * n
            t = b;   b = b2;   b2 = t +  b2 * n
            t = b1; b1 = b12; b12 = t + b12 * n
        }
    }
}

interface ContinuedFraction {
    fun nextTerm(): Int
    fun moreTerms(): Boolean
}

class R2cf(var n1: Int, var n2: Int) : ContinuedFraction {

    override fun nextTerm(): Int {
        val thisTerm = n1 /n2
        val t2 = n2
        n2 = n1 - thisTerm * n2
        n1 = t2
        return thisTerm
    }

    override fun moreTerms() = abs(n2) > 0
}

class NG : ContinuedFraction {
    val ng: MatrixNG
    val n: List<ContinuedFraction>

    constructor(ng: NG4, n1: ContinuedFraction) {
        this.ng = ng
        n = listOf(n1)
    }

    constructor(ng: NG8, n1: ContinuedFraction, n2: ContinuedFraction) {
        this.ng = ng
        n = listOf(n1, n2)
    }

    override fun nextTerm(): Int {
        ng.haveTerm = false
        return ng.thisTerm
    }

    override fun moreTerms(): Boolean {
        while (ng.needTerm()) {
            if (n[ng.cfn].moreTerms())
                ng.consumeTerm(n[ng.cfn].nextTerm())
            else
                ng.consumeTerm()
        }
        return ng.haveTerm
    }
}

fun test(desc: String, vararg cfs: ContinuedFraction) {
    println("TESTING -> $desc")
    for (cf in cfs) {
        while (cf.moreTerms()) print ("${cf.nextTerm()} ")
        println()
    }
    println()
}

fun main(args: Array<String>) {
    val a  = NG8(0, 1, 1, 0, 0, 0, 0, 1)
    val n2 = R2cf(22, 7)
    val n1 = R2cf(1, 2)
    val a3 = NG4(2, 1, 0, 2)
    val n3 = R2cf(22, 7)
    test("[3;7] + [0;2]", NG(a, n1, n2), NG(a3, n3))

    val b  = NG8(1, 0, 0, 0, 0, 0, 0, 1)
    val b1 = R2cf(13, 11)
    val b2 = R2cf(22, 7)
    test("[1;5,2] * [3;7]", NG(b, b1, b2), R2cf(286, 77))

    val c = NG8(0, 1, -1, 0, 0, 0, 0, 1)
    val c1 = R2cf(13, 11)
    val c2 = R2cf(22, 7)
    test("[1;5,2] - [3;7]", NG(c, c1, c2), R2cf(-151, 77))

    val d = NG8(0, 1, 0, 0, 0, 0, 1, 0)
    val d1 = R2cf(22 * 22, 7 * 7)
    val d2 = R2cf(22,7)
    test("Divide [] by [3;7]", NG(d, d1, d2))

    val na = NG8(0, 1, 1, 0, 0, 0, 0, 1)
    val a1 = R2cf(2, 7)
    val a2 = R2cf(13, 11)
    val aa = NG(na, a1, a2)
    val nb = NG8(0, 1, -1, 0, 0, 0, 0, 1)
    val b3 = R2cf(2, 7)
    val b4 = R2cf(13, 11)
    val bb = NG(nb, b3, b4)
    val nc = NG8(1, 0, 0, 0, 0, 0, 0, 1)
    val desc = "([0;3,2] + [1;5,2]) * ([0;3,2] - [1;5,2])"
    test(desc, NG(nc, aa, bb), R2cf(-7797, 5929))
}
