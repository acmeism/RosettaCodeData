// version 1.2.31

import java.io.File

fun main(args: Array<String>) {
    val rx = Regex("""\s+""")
    val file = File("readings.txt")
    var count = 0
    var invalid = 0
    var allGood = 0
    var map = mutableMapOf<String, Int>()
    file.forEachLine { line ->
        count++
        val fields = line.split(rx)
        val date = fields[0]
        if (fields.size == 49) {
            if (map.containsKey(date))
                map[date] = map[date]!! + 1
            else
                map.put(date, 1)
            var good = 0
            for (i in 2 until fields.size step 2) {
                if (fields[i].toInt() >= 1) {
                    good++
                }
            }
            if (good == 24) allGood++
        }
        else invalid++
    }

    println("File = ${file.name}")
    println("\nDuplicated dates:")
    for ((k,v) in map) {
        if (v > 1) println("  $k ($v times)")
    }
    println("\nTotal number of records   : $count")
    var percent = invalid.toDouble() / count * 100.0
    println("Number of invalid records : $invalid (${"%5.2f".format(percent)}%)")
    percent = allGood.toDouble() / count * 100.0
    println("Number which are all good : $allGood (${"%5.2f".format(percent)}%)")
}
