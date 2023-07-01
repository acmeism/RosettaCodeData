// version 1.1.2

class Rational(val num: Long, val den: Long) {
    override fun toString() = "$num/$den"
}

fun decimalToRational(d: Double): Rational {
    val ds = d.toString().trimEnd('0').trimEnd('.')
    val index = ds.indexOf('.')
    if (index == -1) return Rational(ds.toLong(), 1L)
    var num = ds.replace(".", "").toLong()
    var den = 1L
    for (n in 1..(ds.length - index - 1)) den *= 10L
    while (num % 2L == 0L && den % 2L == 0L) {
        num /= 2L
        den /= 2L
    }
    while (num % 5L == 0L && den % 5L == 0L) {
        num /= 5L
        den /= 5L
    }
    return Rational(num, den)
}

fun main(args: Array<String>) {
    val decimals = doubleArrayOf(0.9054054, 0.518518, 2.405308, .75, 0.0, -0.64, 123.0, -14.6)
    for (decimal in decimals)
        println("${decimal.toString().padEnd(9)} = ${decimalToRational(decimal)}")
}
