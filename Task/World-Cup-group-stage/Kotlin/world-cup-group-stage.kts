// version 1.1.2

val games = arrayOf("12", "13", "14", "23", "24", "34")
var results = "000000"

fun nextResult(): Boolean {
    if (results == "222222") return false
    val res = results.toInt(3) + 1
    results = res.toString(3).padStart(6, '0')
    return true
}

fun main(args: Array<String>) {
    val points = Array(4) { IntArray(10) }
    do {
        val records = IntArray(4)
        for (i in 0..5) {
            when (results[i]) {
                '2' -> records[games[i][0] - '1'] += 3
                '1' -> { records[games[i][0] - '1']++ ; records[games[i][1] - '1']++ }
                '0' -> records[games[i][1] - '1'] += 3
            }
        }
        records.sort()
        for (i in 0..3) points[i][records[i]]++
    }
    while(nextResult())
    println("POINTS       0    1    2    3    4    5    6    7    8    9")
    println("-------------------------------------------------------------")
    val places = arrayOf("1st", "2nd", "3rd", "4th")
    for (i in 0..3) {
        print("${places[i]} place    ")
        points[3 - i].forEach { print("%-5d".format(it)) }
        println()
    }
}
