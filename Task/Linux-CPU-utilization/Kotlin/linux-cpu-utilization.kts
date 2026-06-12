// version 1.1.3

import java.io.FileReader
import java.io.BufferedReader

fun main(args: Array<String>) {
    println("CPU usage % at 1 second intervals:\n")
    var prevIdleTime = 0L
    var prevTotalTime = 0L
    repeat(10) {
        val br = BufferedReader(FileReader("/proc/stat"))
        val firstLine = br.readLine().drop(5)  // get rid of cpu plus 2 spaces
        br.close()
        val split = firstLine.split(' ')
        val idleTime = split[3].toLong()
        val totalTime = split.map { it.toLong() }.sum()
        if (it > 0) {
            val deltaIdleTime  = idleTime  - prevIdleTime
            val deltaTotalTime = totalTime - prevTotalTime
            val cpuUsage = (1.0 - deltaIdleTime.toDouble() / deltaTotalTime) * 100.0
            println("$it : ${"%6.3f".format(cpuUsage)}")
        }
        prevIdleTime  = idleTime
        prevTotalTime = totalTime
        Thread.sleep(1000)
    }
}
