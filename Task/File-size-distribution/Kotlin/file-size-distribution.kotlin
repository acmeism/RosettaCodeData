// version 1.2.10

import java.io.File
import kotlin.math.log10
import kotlin.math.floor

fun fileSizeDistribution(path: String) {
    val sizes = IntArray(12)
    val p = File(path)
    val files = p.walk()
    var accessible = 0
    var notAccessible = 0
    var totalSize = 0L
    for (file in files) {
        try {
            if (file.isFile()) {
                val len = file.length()
                accessible++
                if (len == 0L) {
                    sizes[0]++
                    continue
                }
                totalSize += len
                val logLen = log10(len.toDouble())
                val index = floor(logLen).toInt()
                sizes[index + 1]++
            }
        }
        catch (se: SecurityException) {
            notAccessible++
        }
    }

    println("File size distribution for '$path' :-\n")
    for (i in 0 until sizes.size) {
        print(if (i == 0) "  " else "+ ")
        print("Files less than 10 ^ ${"%-2d".format(i)} bytes : ")
        println("%5d".format(sizes[i]))
    }
    println("                                  -----")
    println("= Number of accessible files    : ${"%5d".format(accessible)}")
    println("\n  Total size in bytes           : $totalSize")
    println("\n  Number of inaccessible files  : ${"%5d".format(notAccessible)}")
}

fun main(args: Array<String>) {
    fileSizeDistribution("./")  // current directory
}
