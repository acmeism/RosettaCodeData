fun logicalDemo(b1: Boolean, b2: Boolean) {
    println("b1 = $b1")
    println("b2 = $b2")
    println("non-short-circuiting operators:")
    println("b1 and b2 = ${b1 and b2}")
    println("b1 or b2 = ${b1 or b2}")
    println("b1 xor b2 = ${b1 xor b2}")
    println("not b1 = ${!b1}")
    println("short-circuiting operators:")
    println("b1 && b2 = ${b1 && b2}")
    println("b1 || b2 = ${b1 || b2}")
    println()
}

fun main() {
    logicalDemo(true, true)
    logicalDemo(true, false)
    logicalDemo(false, true)
    logicalDemo(false, false)
}
