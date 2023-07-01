// version 1.2.31

import java.io.File

fun main(args: Array<String>) {
    val rx = Regex("""\s+""")
    val file = File("readings.txt")
    val fmt = "Line:  %s  Reject: %2d  Accept: %2d  Line_tot: %7.3f  Line_avg: %7.3f"
    var grandTotal = 0.0
    var readings = 0
    var date = ""
    var run = 0
    var maxRun = -1
    var finishLine = ""
    file.forEachLine { line ->
        val fields = line.split(rx)
        date = fields[0]
        if (fields.size == 49) {
            var accept = 0
            var total = 0.0
            for (i in 1 until fields.size step 2) {
                if (fields[i + 1].toInt() >= 1) {
                    accept++
                    total += fields[i].toDouble()
                    if (run > maxRun) {
                        maxRun = run
                        finishLine = date
                    }
                    run = 0
                }
                else run++
            }
            grandTotal += total
            readings += accept
            println(fmt.format(date, 24 - accept, accept, total, total / accept))
        }
        else println("Line:  $date does not have 49 fields and has been ignored")
    }

    if (run > maxRun) {
        maxRun = run
        finishLine = date
    }
    val average = grandTotal / readings
    println("\nFile     = ${file.name}")
    println("Total    = ${"%7.3f".format(grandTotal)}")
    println("Readings = $readings")
    println("Average  = ${"%-7.3f".format(average)}")
    println("\nMaximum run of $maxRun consecutive false readings")
    println("ends at line starting with date: $finishLine")
}
