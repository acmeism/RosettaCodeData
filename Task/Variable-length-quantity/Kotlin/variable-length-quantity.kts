// version 1.0.6

fun Int.toOctets(): ByteArray {
    var s = Integer.toBinaryString(this)
    val r = s.length % 7
    var z = s.length / 7
    if (r > 0) {
        z++
        s = s.padStart(z * 7, '0')
    }
    s = Array(z) { "1" + s.slice(it * 7 until (it + 1) * 7) }.joinToString("")
    s = s.take(s.length - 8) + "0" + s.takeLast(7)
    return ByteArray(z) { Integer.parseInt(s.slice(it * 8 until (it + 1) * 8), 2).toByte() }
}

fun ByteArray.fromOctets(): Int {
    var s = ""
    for (b in this) s += Integer.toBinaryString(b.toInt()).padStart(7, '0').takeLast(7)
    return Integer.parseInt(s, 2)
}

fun main(args: Array<String>) {
    val tests = intArrayOf(0x7f, 0x3fff, 0x200000, 0x1fffff)
    for (test in tests) {
        val ba = test.toOctets()
        print("${"0x%x".format(test).padEnd(8)} -> ")
        var s = ""
        ba.forEach { s += "0x%02x ".format(it) }
        println("${s.padEnd(20)} <- ${"0x%x".format(ba.fromOctets())}")
    }
}
