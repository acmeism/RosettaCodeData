// version 1.1.0

fun decToBin(d: Double): String {
    val whole  = Math.floor(d).toLong()
    var binary = whole.toString(2) + "."
    var dd = d - whole
    while (dd > 0.0) {
        val r = dd * 2.0
        if (r >= 1.0) {
            binary += "1"
            dd = r - 1
        }
        else {
            binary += "0"
            dd = r
        }
    }
    return binary
}

fun binToDec(s: String): Double {
    val num = s.replace(".", "").toLong(2)
    val den = ("1" + s.split('.')[1].replace("1", "0")).toLong(2)
    return num.toDouble() / den
}

fun main(args: Array<String>) {
    val d = 23.34375
    println("$d\t => ${decToBin(d)}")
    val s = "1011.11101"
    println("$s\t => ${binToDec(s)}")
}
