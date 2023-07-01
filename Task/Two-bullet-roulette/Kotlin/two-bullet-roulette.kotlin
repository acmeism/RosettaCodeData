import kotlin.random.Random

val cylinder = Array(6) { false }

fun rShift() {
    val t = cylinder[cylinder.size - 1]
    for (i in (0 until cylinder.size - 1).reversed()) {
        cylinder[i + 1] = cylinder[i]
    }
    cylinder[0] = t
}

fun unload() {
    for (i in cylinder.indices) {
        cylinder[i] = false
    }
}

fun load() {
    while (cylinder[0]) {
        rShift()
    }
    cylinder[0] = true
    rShift()
}

fun spin() {
    val lim = Random.nextInt(0, 6) + 1
    for (i in 1..lim) {
        rShift()
    }
}

fun fire(): Boolean {
    val shot = cylinder[0]
    rShift()
    return shot
}

fun method(s: String): Int {
    unload()
    for (c in s) {
        when (c) {
            'L' -> {
                load()
            }
            'S' -> {
                spin()
            }
            'F' -> {
                if (fire()) {
                    return 1
                }
            }
        }
    }
    return 0
}

fun mString(s: String): String {
    val buf = StringBuilder()
    fun append(txt: String) {
        if (buf.isNotEmpty()) {
            buf.append(", ")
        }
        buf.append(txt)
    }
    for (c in s) {
        when (c) {
            'L' -> {
                append("load")
            }
            'S' -> {
                append("spin")
            }
            'F' -> {
                append("fire")
            }
        }
    }
    return buf.toString()
}

fun test(src: String) {
    val tests = 100000
    var sum = 0

    for (t in 0..tests) {
        sum += method(src)
    }

    val str = mString(src)
    val pc = 100.0 * sum / tests
    println("%-40s produces %6.3f%% deaths.".format(str, pc))
}

fun main() {
    test("LSLSFSF");
    test("LSLSFF");
    test("LLSFSF");
    test("LLSFF");
}
