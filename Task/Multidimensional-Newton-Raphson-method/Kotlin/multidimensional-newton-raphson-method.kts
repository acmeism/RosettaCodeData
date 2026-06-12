// Version 1.2.31

import kotlin.math.abs

typealias Vector = DoubleArray
typealias Matrix = Array<Vector>
typealias Func = (Vector) -> Double
typealias Funcs = List<Func>
typealias Jacobian = List<Funcs>

operator fun Matrix.times(other: Matrix): Matrix {
    val rows1 = this.size
    val cols1 = this[0].size
    val rows2 = other.size
    val cols2 = other[0].size
    require(cols1 == rows2)
    val result = Matrix(rows1) { Vector(cols2) }
    for (i in 0 until rows1) {
        for (j in 0 until cols2) {
            for (k in 0 until rows2) {
                result[i][j] += this[i][k] * other[k][j]
            }
        }
    }
    return result
}

operator fun Matrix.minus(other: Matrix): Matrix {
    val rows = this.size
    val cols = this[0].size
    require(rows == other.size && cols == other[0].size)
    val result = Matrix(rows) { Vector(cols) }
    for (i in 0 until rows) {
        for (j in 0 until cols) {
            result[i][j] = this[i][j] - other[i][j]
        }
    }
    return result
}

fun Matrix.transpose(): Matrix {
    val rows = this.size
    val cols = this[0].size
    val trans = Matrix(cols) { Vector(rows) }
    for (i in 0 until cols) {
        for (j in 0 until rows) trans[i][j] = this[j][i]
    }
    return trans
}

fun Matrix.inverse(): Matrix {
    val len = this.size
    require(this.all { it.size == len }) { "Not a square matrix" }
    val aug = Array(len) { DoubleArray(2 * len) }
    for (i in 0 until len) {
        for (j in 0 until len) aug[i][j] = this[i][j]
        // augment by identity matrix to right
        aug[i][i + len] = 1.0
    }
    aug.toReducedRowEchelonForm()
    val inv = Array(len) { DoubleArray(len) }
    // remove identity matrix to left
    for (i in 0 until len) {
        for (j in len until 2 * len) inv[i][j - len] = aug[i][j]
    }
    return inv
}

fun Matrix.toReducedRowEchelonForm() {
    var lead = 0
    val rowCount = this.size
    val colCount = this[0].size
    for (r in 0 until rowCount) {
        if (colCount <= lead) return
        var i = r

        while (this[i][lead] == 0.0) {
            i++
            if (rowCount == i) {
                i = r
                lead++
                if (colCount == lead) return
            }
        }

        val temp = this[i]
        this[i] = this[r]
        this[r] = temp

        if (this[r][lead] != 0.0) {
           val div = this[r][lead]
           for (j in 0 until colCount) this[r][j] /= div
        }

        for (k in 0 until rowCount) {
            if (k != r) {
                val mult = this[k][lead]
                for (j in 0 until colCount) this[k][j] -= this[r][j] * mult
            }
        }

        lead++
    }
}

fun solve(funcs: Funcs, jacobian: Jacobian, guesses: Vector): Vector {
    val size = funcs.size
    var gu1: Vector
    var gu2 = guesses.copyOf()
    val jac = Matrix(size) { Vector(size) }
    val tol = 1.0e-8
    val maxIter = 12
    var iter = 0
    do {
        gu1 = gu2
        val g = arrayOf(gu1).transpose()
        val f = arrayOf(Vector(size) { funcs[it](gu1) }).transpose()
        for (i in 0 until size) {
            for (j in 0 until size) {
                jac[i][j] = jacobian[i][j](gu1)
            }
        }
        val g1 = g - jac.inverse() * f
        gu2 = Vector(size) { g1[it][0] }
        iter++
    }
    while (gu2.withIndex().any { iv -> abs(iv.value - gu1[iv.index]) > tol } && iter < maxIter)
    return gu2
}

fun main(args: Array<String>) {
    /* solve the two non-linear equations:
       y = -x^2 + x + 0.5
       y + 5xy = x^2
       given initial guesses of x = y = 1.2

       Example taken from:
       http://www.fixoncloud.com/Home/LoginValidate/OneProblemComplete_Detailed.php?problemid=286

       Expected results: x = 1.23332, y = 0.2122
    */

    val f1: Func = { x -> -x[0] * x[0] + x[0] + 0.5 - x[1] }
    val f2: Func = { x -> x[1] + 5 * x[0] * x[1] - x[0] * x[0] }
    val funcs = listOf(f1, f2)
    val jacobian = listOf(
        listOf<Func>({ x -> - 2.0 * x[0] + 1.0 }, { _ -> -1.0 }),
        listOf<Func>({ x -> 5.0 * x[1] - 2.0 * x[0] }, { x -> 1.0 + 5.0 * x[0] })
    )
    val guesses = doubleArrayOf(1.2, 1.2)
    val (xx, yy) = solve(funcs, jacobian, guesses)
    System.out.printf("Approximate solutions are x = %.7f,  y = %.7f\n", xx, yy)

    /* solve the three non-linear equations:
       9x^2 + 36y^2 + 4z^2 - 36 = 0
       x^2 - 2y^2 - 20z = 0
       x^2 - y^2 + z^2 = 0
       given initial guesses of x = y = 1.0 and z = 0.0

       Example taken from:
       http://mathfaculty.fullerton.edu/mathews/n2003/FixPointNewtonMod.html (exercise 5)

       Expected results: x = 0.893628, y = 0.894527, z = -0.0400893
    */

    println()
    val f3: Func = { x -> 9.0 * x[0] * x[0] + 36.0 * x[1] * x[1] + 4.0 * x[2] * x[2] - 36.0 }
    val f4: Func = { x -> x[0] * x[0] - 2.0 * x[1] * x[1] - 20.0 * x[2] }
    val f5: Func = { x -> x[0] * x[0] - x[1] * x[1] + x[2] * x[2] }
    val funcs2 = listOf(f3, f4, f5)
    val jacobian2 = listOf(
        listOf<Func>({ x -> 18.0 * x[0] }, { x -> 72.0 * x[1] }, { x -> 8.0 * x[2] }),
        listOf<Func>({ x -> 2.0 * x[0] }, { x -> -4.0 * x[1] }, { _ -> -20.0 }),
        listOf<Func>({ x -> 2.0 * x[0] }, { x -> -2.0 * x[1] }, { x -> 2.0 * x[2] })
    )
    val guesses2 = doubleArrayOf(1.0, 1.0, 0.0)
    val (xx2, yy2, zz2) = solve(funcs2, jacobian2, guesses2)
    System.out.printf("Approximate solutions are x = %.7f,  y = %.7f,  z = %.7f\n", xx2, yy2, zz2)
}
