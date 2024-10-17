// version 1.0.6

fun romanDecode(roman: String): Int {
    if (roman.isEmpty()) return 0
    var n = 0
    var last = 'O'
    for (c in roman) {
        when (c) {
            'I' -> n += 1
            'V' -> if (last == 'I') n += 3   else n += 5
            'X' -> if (last == 'I') n += 8   else n += 10
            'L' -> if (last == 'X') n += 30  else n += 50
            'C' -> if (last == 'X') n += 80  else n += 100
            'D' -> if (last == 'C') n += 300 else n += 500
            'M' -> if (last == 'C') n += 800 else n += 1000
        }
        last = c
    }
    return n
}

fun main(args: Array<String>) {
    val romans = arrayOf("I", "III", "IV", "VIII", "XLIX", "CCII", "CDXXXIII", "MCMXC", "MMVIII", "MDCLXVI")
    for (roman in romans) println("${roman.padEnd(10)} = ${romanDecode(roman)}")
}
