// version 1.1.2

inline fun <reified T : Comparable<T>> sortThree(x: T, y: T, z: T): Triple<T, T, T> {
    val a = arrayOf(x, y, z)
    a.sort()
    return Triple(a[0], a[1], a[2])
}

fun <T> printThree(x: T, y: T, z: T) = println("x = $x\ny = $y\nz = $z\n")

fun main(args: Array<String>) {
    var x = "lions, tigers, and"
    var y = "bears, oh my!"
    var z = """(from the "Wizard of OZ")"""
    val t = sortThree(x, y, z)
    x = t.first
    y = t.second
    z = t.third
    printThree(x, y, z)

    var x2 = 77444
    var y2 = -12
    var z2 = 0
    val t2 = sortThree(x2, y2, z2)
    x2 = t2.first
    y2 = t2.second
    z2 = t2.third
    printThree(x2, y2, z2)

    var x3 = 174.5
    var y3 = -62.5
    var z3 = 41.7
    val t3 = sortThree(x3, y3, z3)
    x3 = t3.first
    y3 = t3.second
    z3 = t3.third
    printThree(x3, y3, z3)
}
