// version 1.1.51

import java.util.Random

typealias Func = (DoubleArray) -> Double

class Parameters(val omega: Double, val phip: Double, val phig: Double)

class State(
    val iter: Int,
    val gbpos: DoubleArray,
    val gbval: Double,
    val min: DoubleArray,
    val max: DoubleArray,
    val parameters: Parameters,
    val pos: Array<DoubleArray>,
    val vel: Array<DoubleArray>,
    val bpos: Array<DoubleArray>,
    val bval: DoubleArray,
    val nParticles: Int,
    val nDims: Int
) {
    fun report(testfunc: String) {
        println("Test Function        : $testfunc")
        println("Iterations           : $iter")
        println("Global Best Position : ${gbpos.asList()}")
        println("Global Best Value    : $gbval")
    }
}

fun psoInit(
    min: DoubleArray,
    max: DoubleArray,
    parameters: Parameters,
    nParticles: Int
): State {
    val nDims = min.size
    val pos   = Array(nParticles) { min }
    val vel   = Array(nParticles) { DoubleArray(nDims) }
    val bpos  = Array(nParticles) { min }
    val bval  = DoubleArray(nParticles) { Double.POSITIVE_INFINITY}
    val iter  = 0
    val gbpos = DoubleArray(nDims) { Double.POSITIVE_INFINITY }
    val gbval = Double.POSITIVE_INFINITY
    return State(iter, gbpos, gbval, min, max, parameters,
                 pos, vel, bpos, bval, nParticles, nDims)
}

val r = Random()

fun pso(fn: Func, y: State): State {
    val p = y.parameters
    val v = DoubleArray(y.nParticles)
    val bpos  = Array(y.nParticles) { y.min }
    val bval  = DoubleArray(y.nParticles)
    var gbpos = DoubleArray(y.nDims)
    var gbval = Double.POSITIVE_INFINITY
    for (j in 0 until y.nParticles) {
        // evaluate
        v[j] = fn(y.pos[j])
        // update
        if (v[j] < y.bval[j]) {
            bpos[j] = y.pos[j]
            bval[j] = v[j]
        }
        else {
            bpos[j] = y.bpos[j]
            bval[j] = y.bval[j]
        }
        if (bval[j] < gbval) {
            gbval = bval[j]
            gbpos = bpos[j]
        }
    }
    val rg = r.nextDouble()
    val pos = Array(y.nParticles) { DoubleArray(y.nDims) }
    val vel = Array(y.nParticles) { DoubleArray(y.nDims) }
    for (j in 0 until y.nParticles) {
        // migrate
        val rp = r.nextDouble()
        var ok = true
        vel[j].fill(0.0)
        pos[j].fill(0.0)
        for (k in 0 until y.nDims) {
            vel[j][k] = p.omega * y.vel[j][k] +
                        p.phip * rp * (bpos[j][k] - y.pos[j][k]) +
                        p.phig * rg * (gbpos[k] - y.pos[j][k])
            pos[j][k] = y.pos[j][k] + vel[j][k]
            ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k]
        }
        if (!ok) {
            for (k in 0 until y.nDims) {
                pos[j][k]= y.min[k] + (y.max[k] - y.min[k]) * r.nextDouble()
            }
        }
    }
    val iter = 1 + y.iter
    return State(
        iter, gbpos, gbval, y.min, y.max, y.parameters,
        pos, vel, bpos, bval, y.nParticles, y.nDims
    )
}

fun iterate(fn: Func, n: Int, y: State): State {
    var r = y
    var old = y
    if (n == Int.MAX_VALUE) {
        while (true) {
            r = pso(fn, r)
            if (r == old) break
            old = r
        }
    }
    else {
        repeat(n) { r = pso(fn, r) }
    }
    return r
}

fun mccormick(x: DoubleArray): Double {
    val (a, b) = x
    return Math.sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a
}

fun michalewicz(x: DoubleArray): Double {
    val m = 10
    val d = x.size
    var sum = 0.0
    for (i in 1..d) {
        val j = x[i - 1]
        val k = Math.sin(i * j * j / Math.PI)
        sum += Math.sin(j) * Math.pow(k, 2.0 * m)
    }
    return -sum
}

fun main(args: Array<String>) {
    var state = psoInit(
        min = doubleArrayOf(-1.5, -3.0),
        max = doubleArrayOf(4.0, 4.0),
        parameters = Parameters(0.0, 0.6, 0.3),
        nParticles = 100
    )
    state = iterate(::mccormick, 40, state)
    state.report("McCormick")
    println("f(-.54719, -1.54719) : ${mccormick(doubleArrayOf(-.54719, -1.54719))}")
    println()
    state = psoInit(
        min = doubleArrayOf(0.0, 0.0),
        max = doubleArrayOf(Math.PI, Math.PI),
        parameters = Parameters(0.3, 0.3, 0.3),
        nParticles = 1000
    )
    state = iterate(::michalewicz, 30, state)
    state.report("Michalewicz (2D)")
    println("f(2.20, 1.57)        : ${michalewicz(doubleArrayOf(2.2, 1.57))}")
}
