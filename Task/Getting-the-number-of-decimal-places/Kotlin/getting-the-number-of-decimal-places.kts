fun findNumOfDec(x: Double): Int {
    val str = x.toString()
    if (str.endsWith(".0")) {
        return 0
    }
    return str.substring(str.indexOf('.')).length - 1
}

fun main() {
    for (n in listOf(12.0, 12.345, 12.345555555555, 12.3450, 12.34555555555555555555, 1.2345e+54)) {
        println("%f has %d decimals".format(n, findNumOfDec(n)))
    }
}
