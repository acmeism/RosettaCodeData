import java.math.BigDecimal
import java.math.BigInteger

val names = listOf("Platinum", "Golden", "Silver", "Bronze", "Copper", "Nickel", "Aluminium", "Iron", "Tin", "Lead")

fun lucas(b: Long) {
    println("Lucas sequence for ${names[b.toInt()]} ratio, where b = $b:")
    print("First 15 elements: ")
    var x0 = 1L
    var x1 = 1L
    print("$x0, $x1")
    for (i in 1..13) {
        val x2 = b * x1 + x0
        print(", $x2")
        x0 = x1
        x1 = x2
    }
    println()
}

fun metallic(b: Long, dp:Int) {
    var x0 = BigInteger.ONE
    var x1 = BigInteger.ONE
    var x2: BigInteger
    val bb = BigInteger.valueOf(b)
    val ratio = BigDecimal.ONE.setScale(dp)
    var iters = 0
    var prev = ratio.toString()
    while (true) {
        iters++
        x2 = bb * x1 + x0
        val thiz = (x2.toBigDecimal(dp) / x1.toBigDecimal(dp)).toString()
        if (prev == thiz) {
            var plural = "s"
            if (iters == 1) {
                plural = ""
            }
            println("Value after $iters iteration$plural: $thiz\n")
            return
        }
        prev = thiz
        x0 = x1
        x1 = x2
    }
}

fun main() {
    for (b in 0L until 10L) {
        lucas(b)
        metallic(b, 32)
    }
    println("Golden ration, where b = 1:")
    metallic(1, 256)
}
