// version 1.1.51

typealias Matrix = Array<DoubleArray>
typealias Op = Double.(Double) -> Double

fun Double.dPow(exp: Double) = Math.pow(this, exp)

fun Matrix.elementwiseOp(other: Matrix, op: Op): Matrix {
    require(this.size == other.size && this[0].size == other[0].size)
    val result = Array(this.size) { DoubleArray(this[0].size) }
    for (i in 0 until this.size) {
        for (j in 0 until this[0].size) result[i][j] = this[i][j].op(other[i][j])
    }
    return result
}

fun Matrix.elementwiseOp(d: Double, op: Op): Matrix {
    val result = Array(this.size) { DoubleArray(this[0].size) }
    for (i in 0 until this.size) {
        for (j in 0 until this[0].size) result[i][j] = this[i][j].op(d)
    }
    return result
}

fun Matrix.print(name: Char?, scalar: Boolean? = false) {
    println(when (scalar) {
        true  -> "m $name s"
        false -> "m $name m"
        else  -> "m"
    } + ":")
    for (i in 0 until this.size) println(this[i].asList())
    println()
}

fun main(args: Array<String>) {
    val ops = listOf(Double::plus, Double::minus, Double::times, Double::div, Double::dPow)
    val names = "+-*/^"
    val m = arrayOf(
        doubleArrayOf(3.0, 5.0, 7.0),
        doubleArrayOf(1.0, 2.0, 3.0),
        doubleArrayOf(2.0, 4.0, 6.0)
    )
    m.print(null, null)
    for ((i, op) in ops.withIndex()) m.elementwiseOp(m, op).print(names[i])
    val s = 2.0
    println("s = $s:\n")
    for ((i, op) in ops.withIndex()) m.elementwiseOp(s, op).print(names[i], true)
}
