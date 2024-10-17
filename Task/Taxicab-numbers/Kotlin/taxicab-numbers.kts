// version 1.0.6

import java.util.PriorityQueue

class CubeSum(val x: Long, val y: Long) : Comparable<CubeSum> {
    val value: Long = x * x * x + y * y * y

    override fun toString() = String.format("%4d^3 + %3d^3", x, y)

    override fun compareTo(other: CubeSum) = value.compareTo(other.value)
}

class SumIterator : Iterator<CubeSum> {
    private val pq = PriorityQueue<CubeSum>()
    private var n = 0L

    override fun hasNext() = true

    override fun next(): CubeSum {
        while (pq.size == 0 || pq.peek().value >= n * n * n)
            pq.add(CubeSum(++n, 1))
        val s: CubeSum = pq.remove()
        if (s.x > s.y + 1) pq.add(CubeSum(s.x, s.y + 1))
        return s
    }
}

class TaxiIterator : Iterator<MutableList<CubeSum>> {
    private val sumIterator = SumIterator()
    private var last: CubeSum = sumIterator.next()

    override fun hasNext() = true

    override fun next(): MutableList<CubeSum> {
        var s: CubeSum = sumIterator.next()
        val train = mutableListOf<CubeSum>()
        while (s.value != last.value) {
            last = s
            s = sumIterator.next()
        }
        train.add(last)
        do {
            train.add(s)
            s = sumIterator.next()
        }
        while (s.value == last.value)
        last = s
        return train
    }
}

fun main(args: Array<String>) {
    val taxi = TaxiIterator()
    for (i in 1..2006) {
        val t = taxi.next()
        if (i in 26 until 2000) continue
        print(String.format("%4d: %10d", i, t[0].value))
        for (s in t) print("  = $s")
        println()
    }
}
