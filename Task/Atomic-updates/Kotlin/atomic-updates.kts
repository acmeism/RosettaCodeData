// version 1.2.0

import java.util.concurrent.ThreadLocalRandom
import kotlin.concurrent.thread

const val NUM_BUCKETS = 10

class Buckets(data: IntArray) {
    private val data = data.copyOf()

    operator fun get(index: Int) = synchronized(data) { data[index] }

    fun transfer(srcIndex: Int, dstIndex: Int, amount: Int): Int {
        if (amount < 0) {
            throw IllegalArgumentException("Negative amount: $amount")
        }
        if (amount == 0) return 0
        synchronized(data) {
            var a = amount
            if (data[srcIndex] - a < 0) a = data[srcIndex]
            if (data[dstIndex] + a < 0) a = Int.MAX_VALUE - data[dstIndex]
            if (a < 0) throw IllegalStateException()
            data[srcIndex] -= a
            data[dstIndex] += a
            return a
        }
    }

    val buckets get() = synchronized(data) { data.copyOf() }

    fun transferRandomAmount() {
        val rnd = ThreadLocalRandom.current()
        while (true) {
            val srcIndex = rnd.nextInt(NUM_BUCKETS)
            val dstIndex = rnd.nextInt(NUM_BUCKETS)
            val amount = rnd.nextInt() and Int.MAX_VALUE
            transfer(srcIndex, dstIndex, amount)
        }
    }

    fun equalize() {
        val rnd = ThreadLocalRandom.current()
        while (true) {
            val srcIndex = rnd.nextInt(NUM_BUCKETS)
            val dstIndex = rnd.nextInt(NUM_BUCKETS)
            val amount = (this[srcIndex] - this[dstIndex]) / 2
            if (amount >= 0) transfer(srcIndex, dstIndex, amount)
        }
    }

    fun print() {
        while (true) {
            val nextPrintTime = System.currentTimeMillis() + 3000
            while (true) {
                val now = System.currentTimeMillis()
                if (now >= nextPrintTime) break
                try {
                    Thread.sleep(nextPrintTime - now)
                }
                catch (e: InterruptedException) {
                    return
                }
            }
            val bucketValues = buckets
            println("Current values: ${bucketValues.total} ${bucketValues.asList()}")
        }
    }
}

val IntArray.total: Long get() {
    var sum = 0L
    for (d in this) sum += d
    return sum
}

fun main(args: Array<String>) {
    val rnd = ThreadLocalRandom.current()
    val values = IntArray(NUM_BUCKETS) { rnd.nextInt() and Int.MAX_VALUE }
    println("Initial array:  ${values.total} ${values.asList()}")
    val buckets = Buckets(values)
    thread(name = "equalizer")   { buckets.equalize() }
    thread(name = "transferrer") { buckets.transferRandomAmount() }
    thread(name = "printer")     { buckets.print() }
}
