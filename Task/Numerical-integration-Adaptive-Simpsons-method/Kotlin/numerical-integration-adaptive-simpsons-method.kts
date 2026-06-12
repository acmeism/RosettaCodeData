// Version 1.2.71

import kotlin.math.abs
import kotlin.math.sin

typealias F = (Double) -> Double
typealias T = Triple<Double, Double, Double>

/* "structured" adaptive version, translated from Racket */
fun quadSimpsonsMem(f: F, a: Double, fa: Double, b: Double, fb: Double): T {
    // Evaluates Simpson's Rule, also returning m and f(m) to reuse
    val m = (a + b) / 2
    val fm = f(m)
    val simp = abs(b - a) / 6 * (fa + 4 * fm + fb)
    return T(m, fm, simp)
}

fun quadAsrRec(f: F, a: Double, fa: Double, b: Double, fb: Double,
    eps: Double, whole: Double, m: Double, fm: Double): Double {
    // Efficient recursive implementation of adaptive Simpson's rule.
    // Function values at the start, middle, end of the intervals are retained.
    val (lm, flm, left) = quadSimpsonsMem(f, a, fa, m, fm)
    val (rm, frm, right) = quadSimpsonsMem(f, m, fm, b, fb)
    val delta = left + right - whole
    if (abs(delta) <= eps * 15)  return left + right + delta / 15
    return quadAsrRec(f, a, fa, m, fm, eps / 2, left, lm, flm) +
        quadAsrRec(f, m, fm, b, fb, eps / 2, right, rm, frm)
}

fun quadAsr(f: F, a: Double, b: Double, eps: Double): Double {
    // Integrate f from a to b using ASR with max error of eps.
    val fa = f(a)
    val fb = f(b)
    val (m, fm, whole) = quadSimpsonsMem(f, a, fa, b, fb)
    return quadAsrRec(f, a, fa, b, fb, eps, whole, m, fm)
}

fun main(args: Array<String>) {
    val a = 0.0
    val b = 1.0
    val sinx = quadAsr(::sin, a, b, 1.0e-09)
    println("Simpson's integration of sine from $a to $b = ${"%6f".format(sinx)}")
}
