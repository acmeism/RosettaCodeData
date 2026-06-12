import java.math.BigInteger

fun digitSum(bi: BigInteger): Int {
    var bi2 = bi
    var sum = 0
    while (bi2 > BigInteger.ZERO) {
        val dr = bi2.divideAndRemainder(BigInteger.TEN)
        sum += dr[1].toInt()
        bi2 = dr[0]
    }
    return sum
}

fun main() {
    val fiveK = BigInteger.valueOf(5_000)

    var bi = BigInteger.valueOf(2)
    while (bi < fiveK) {
        if (digitSum(bi) == 25) {
            print(bi)
            print("  ")
        }

        bi = bi.nextProbablePrime()
    }
    println()
}
