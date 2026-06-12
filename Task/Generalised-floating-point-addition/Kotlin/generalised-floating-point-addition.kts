// version 1.2.10

import java.math.BigDecimal

fun BigDecimal.repeatedAdd(times: Int): BigDecimal {
    var sum = BigDecimal.ZERO
    for (i in 0 until times) sum += this
    return sum
}

fun main(args: Array<String>) {
    var s = "12345679"
    val t = "123456790"
    var e = 63
    for (n in -7..21) {
        val bd = BigDecimal("${s}e$e")
        val oneE = BigDecimal("1e$e")
        val temp = bd.repeatedAdd(9)
        val result = temp.repeatedAdd(9) + oneE
        println("%2d : %e".format(n, result))
        s = t + s
        e -= 9
    }
}
