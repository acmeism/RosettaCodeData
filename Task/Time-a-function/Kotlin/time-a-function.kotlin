// version 1.1.2
// need to enable runtime assertions with JVM -ea option

import java.lang.management.ManagementFactory
import java.lang.management.ThreadMXBean

fun countTo(x: Int) {
    println("Counting...");
    (1..x).forEach {}
    println("Done!")
}

fun main(args: Array<String>) {
    val counts = intArrayOf(100_000_000, 1_000_000_000)
    val threadMX = ManagementFactory.getThreadMXBean()
    assert(threadMX.isCurrentThreadCpuTimeSupported)
    threadMX.isThreadCpuTimeEnabled = true
    for (count in counts) {
        val start = threadMX.currentThreadCpuTime
        countTo(count)
        val end = threadMX.currentThreadCpuTime
        println("Counting to $count takes ${(end-start)/1000000}ms")
    }
}
