// version 1.1.51

import java.io.File

fun main(args: Array<String>) {
    val filePath = "mlijobs.txt"
    var licenses = 0
    var maxLicenses = 0
    val dates = mutableListOf<String>()
    val f = File(filePath)

    f.forEachLine { line ->
        if (line.startsWith("License OUT")) {
            licenses++
            if (licenses > maxLicenses) {
                maxLicenses = licenses
                dates.clear()
                dates.add(line.substring(14, 33))
            }
            else if(licenses == maxLicenses) {
                dates.add(line.substring(14, 33))
            }
        }
        else if (line.startsWith("License IN")) {
            licenses--
        }
    }
    println("Maximum simultaneous license use is $maxLicenses at the following time(s):")
    println(dates.map { "  $it" }.joinToString("\n"))
}
