// Version 1.2.70

val squares13 = mutableMapOf<Int, Int>()
val squares10000 = mutableMapOf<Int, Int>()

class Trio(val a: Int, val b: Int, val c: Int) {
    override fun toString() = "($a $b $c)"
}

fun init() {
    for (i in 1..13) squares13.put(i * i, i)
    for (i in 1..10000) squares10000.put(i * i, i)
}

fun solve(angle :Int, maxLen: Int, allowSame: Boolean): List<Trio> {
    val solutions = mutableListOf<Trio>()
    for (a in 1..maxLen) {
        inner@ for (b in a..maxLen) {
            var lhs = a * a + b * b
            if (angle != 90) {
                when (angle) {
                    60   -> lhs -= a * b
                    120  -> lhs += a * b
                    else -> throw RuntimeException("Angle must be 60, 90 or 120 degrees")
                }
            }
            when (maxLen) {
                13 -> {
                    val c = squares13[lhs]
                    if (c != null) {
                        if (!allowSame && a == b && b == c) continue@inner
                        solutions.add(Trio(a, b, c))
                    }
                }

                10000 -> {
                    val c = squares10000[lhs]
                    if (c != null) {
                        if (!allowSame && a == b && b == c) continue@inner
                        solutions.add(Trio(a, b, c))
                    }
                }

                else -> throw RuntimeException("Maximum length must be either 13 or 10000")
            }
        }
    }
    return solutions
}

fun main(args: Array<String>) {
    init()
    print("For sides in the range [1, 13] ")
    println("where they can all be of the same length:-\n")
    val angles = intArrayOf(90, 60, 120)
    lateinit var solutions: List<Trio>
    for (angle in angles) {
        solutions = solve(angle, 13, true)
        print("  For an angle of ${angle} degrees")
        println(" there are ${solutions.size} solutions, namely:")
        println("  ${solutions.joinToString(" ", "[", "]")}\n")
    }
    print("For sides in the range [1, 10000] ")
    println("where they cannot ALL be of the same length:-\n")
    solutions = solve(60, 10000, false)
    print("  For an angle of 60 degrees")
    println(" there are ${solutions.size} solutions.")
}
