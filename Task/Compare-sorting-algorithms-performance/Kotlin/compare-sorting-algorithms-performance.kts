// Version 1.2.31

import java.util.Random
import kotlin.system.measureNanoTime

typealias Sorter = (IntArray) -> Unit

val rand = Random()

fun onesSeq(n: Int) = IntArray(n) { 1 }

fun ascendingSeq(n: Int) = shuffledSeq(n).sorted().toIntArray()

fun shuffledSeq(n: Int) = IntArray(n) { 1 + rand.nextInt(10 * n) }

fun bubbleSort(a: IntArray) {
    var n = a.size
    do {
        var n2 = 0
        for (i in 1 until n) {
            if (a[i - 1] > a[i]) {
                val tmp = a[i]
                a[i] = a[i - 1]
                a[i - 1] = tmp
                n2 = i
            }
        }
        n = n2
    } while (n != 0)
}

fun insertionSort(a: IntArray) {
    for (index in 1 until a.size) {
        val value = a[index]
        var subIndex = index - 1
        while (subIndex >= 0 && a[subIndex] > value) {
            a[subIndex + 1] = a[subIndex]
            subIndex--
        }
        a[subIndex + 1] = value
    }
}

fun quickSort(a: IntArray) {
    fun sorter(first: Int, last: Int) {
        if (last - first < 1) return
        val pivot = a[first + (last - first) / 2]
        var left = first
        var right = last
        while (left <= right) {
            while (a[left] < pivot) left++
            while (a[right] > pivot) right--
            if (left <= right) {
                val tmp = a[left]
                a[left] = a[right]
                a[right] = tmp
                left++
                right--
            }
        }
        if (first < right) sorter(first, right)
        if (left < last) sorter(left, last)
    }
    sorter(0, a.lastIndex)
}

fun radixSort(a: IntArray) {
    val tmp = IntArray(a.size)
    for (shift in 31 downTo 0) {
        tmp.fill(0)
        var j = 0
        for (i in 0 until a.size) {
            val move = (a[i] shl shift) >= 0
            val toBeMoved = if (shift == 0) !move else move
            if (toBeMoved)
                tmp[j++] = a[i]
            else {
                a[i - j] = a[i]
            }
        }
        for (i in j until tmp.size) tmp[i] = a[i - j]
        for (i in 0 until a.size) a[i] = tmp[i]
    }
}

val gaps = listOf(701, 301, 132, 57, 23, 10, 4, 1)  // Marcin Ciura's gap sequence

fun shellSort(a: IntArray) {
    for (gap in gaps) {
        for (i in gap until a.size) {
            val temp = a[i]
            var j = i
            while (j >= gap && a[j - gap] > temp) {
                a[j] = a[j - gap]
                j -= gap
            }
            a[j] = temp
        }
    }
}

fun main(args: Array<String>) {
    val runs = 10
    val lengths = listOf(1, 10, 100, 1_000, 10_000, 100_000)
    val sorts = listOf<Sorter>(
        ::bubbleSort, ::insertionSort, ::quickSort, ::radixSort, ::shellSort
    )

    /* allow JVM to compile sort functions before timings start */
    for (sort in sorts) sort(intArrayOf(1))

    val sortTitles = listOf("Bubble", "Insert", "Quick ", "Radix ", "Shell ")
    val seqTitles = listOf("All Ones", "Ascending", "Shuffled")
    val totals = List(seqTitles.size) { List(sorts.size) { LongArray(lengths.size) } }
    for ((k, n) in lengths.withIndex()) {
        val seqs = listOf(onesSeq(n), ascendingSeq(n), shuffledSeq(n))
        repeat(runs) {
            for (i in 0 until seqs.size) {
                for (j in 0 until sorts.size) {
                    val seq = seqs[i].copyOf()
                    totals[i][j][k] += measureNanoTime { sorts[j](seq) }
                }
            }
        }
    }
    println("All timings in micro-seconds\n")
    print("Sequence length")
    for (len in lengths) print("%8d   ".format(len))
    println("\n")
    for (i in 0 until seqTitles.size) {
        println("  ${seqTitles[i]}:")
        for (j in 0 until sorts.size) {
            print("    ${sortTitles[j]}     ")
            for (k in 0 until lengths.size) {
                val time = totals[i][j][k] / runs / 1_000
                print("%8d   ".format(time))
            }
            println()
        }
        println("\n")
    }
}
