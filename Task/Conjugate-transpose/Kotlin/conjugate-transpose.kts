// version 1.1.3

typealias C = Complex
typealias Vector = Array<C>
typealias Matrix = Array<Vector>

class Complex(val real: Double, val imag: Double) {

    operator fun plus(other: Complex) =
        Complex(this.real + other.real, this.imag + other.imag)

    operator fun times(other: Complex) =
        Complex(this.real * other.real - this.imag * other.imag,
                this.real * other.imag + this.imag * other.real)

    fun conj() = Complex(this.real, -this.imag)

    /* tolerable equality allowing for rounding of Doubles */
    infix fun teq(other: Complex) =
        Math.abs(this.real - other.real) <= 1e-14 &&
        Math.abs(this.imag - other.imag) <= 1e-14

    override fun toString() = "${"%.3f".format(real)} " + when {
        imag > 0.0   -> "+ ${"%.3f".format(imag)}i"
        imag == 0.0  -> "+ 0.000i"
        else         -> "- ${"%.3f".format(-imag)}i"
    }
}

fun Matrix.conjTranspose(): Matrix {
    val rows = this.size
    val cols = this[0].size
    return Matrix(cols) { i -> Vector(rows) { j -> this[j][i].conj() } }
}

operator fun Matrix.times(other: Matrix): Matrix {
    val rows1 = this.size
    val cols1 = this[0].size
    val rows2 = other.size
    val cols2 = other[0].size
    require(cols1 == rows2)
    val result = Matrix(rows1) { Vector(cols2) { C(0.0, 0.0) } }
    for (i in 0 until rows1) {
        for (j in 0 until cols2) {
            for (k in 0 until rows2) {
                result[i][j] += this[i][k] * other[k][j]
            }
        }
    }
    return result
}

/* tolerable matrix equality using the same concept as for complex numbers */
infix fun Matrix.teq(other: Matrix): Boolean {
    if (this.size != other.size || this[0].size != other[0].size) return false
    for (i in 0 until this.size) {
        for (j in 0 until this[0].size) if (!(this[i][j] teq other[i][j])) return false
    }
    return true
}

fun Matrix.isHermitian() = this teq this.conjTranspose()

fun Matrix.isNormal(): Boolean {
    val ct = this.conjTranspose()
    return (this * ct) teq (ct * this)
}

fun Matrix.isUnitary(): Boolean {
    val ct = this.conjTranspose()
    val prod = this * ct
    val ident = identityMatrix(prod.size)
    val prod2 = ct * this
    return (prod teq ident) && (prod2 teq ident)
}

fun Matrix.print() {
    val rows = this.size
    val cols = this[0].size
    for (i in 0 until rows) {
        for (j in 0 until cols) {
            print(this[i][j])
            print(if(j < cols - 1) ",  " else "\n")
        }
    }
    println()
}

fun identityMatrix(n: Int): Matrix {
    require(n >= 1)
    val ident = Matrix(n) { Vector(n) { C(0.0, 0.0) } }
    for (i in 0 until n) ident[i][i] = C(1.0, 0.0)
    return ident
}

fun main(args: Array<String>) {
    val x = Math.sqrt(2.0) / 2.0
    val matrices = arrayOf(
        arrayOf(
            arrayOf(C(3.0,  0.0), C(2.0, 1.0)),
            arrayOf(C(2.0, -1.0), C(1.0, 0.0))
        ),
        arrayOf(
            arrayOf(C(1.0, 0.0), C(1.0, 0.0), C(0.0, 0.0)),
            arrayOf(C(0.0, 0.0), C(1.0, 0.0), C(1.0, 0.0)),
            arrayOf(C(1.0, 0.0), C(0.0, 0.0), C(1.0, 0.0))
        ),
        arrayOf(
            arrayOf(C(x,   0.0), C(x,   0.0), C(0.0, 0.0)),
            arrayOf(C(0.0,  -x), C(0.0,   x), C(0.0, 0.0)),
            arrayOf(C(0.0, 0.0), C(0.0, 0.0), C(0.0, 1.0))
        )
    )

    for (m in matrices) {
        println("Matrix:")
        m.print()
        val mct = m.conjTranspose()
        println("Conjugate transpose:")
        mct.print()
        println("Hermitian? ${mct.isHermitian()}")
        println("Normal?    ${mct.isNormal()}")
        println("Unitary?   ${mct.isUnitary()}\n")
    }
}
