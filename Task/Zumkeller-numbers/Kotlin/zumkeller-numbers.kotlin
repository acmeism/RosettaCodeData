import java.util.ArrayList
import kotlin.math.sqrt

object ZumkellerNumbers {
    @JvmStatic
    fun main(args: Array<String>) {
        var n = 1
        println("First 220 Zumkeller numbers:")
        run {
            var count = 1
            while (count <= 220) {
                if (isZumkeller(n)) {
                    print("%3d  ".format(n))
                    if (count % 20 == 0) {
                        println()
                    }
                    count++
                }
                n += 1
            }
        }

        n = 1
        println("\nFirst 40 odd Zumkeller numbers:")
        run {
            var count = 1
            while (count <= 40) {
                if (isZumkeller(n)) {
                    print("%6d".format(n))
                    if (count % 10 == 0) {
                        println()
                    }
                    count++
                }
                n += 2
            }
        }

        n = 1
        println("\nFirst 40 odd Zumkeller numbers that do not end in a 5:")
        var count = 1
        while (count <= 40) {
            if (n % 5 != 0 && isZumkeller(n)) {
                print("%8d".format(n))
                if (count % 10 == 0) {
                    println()
                }
                count++
            }
            n += 2
        }
    }

    private fun isZumkeller(n: Int): Boolean { //  numbers congruent to 6 or 12 modulo 18 are Zumkeller numbers
        if (n % 18 == 6 || n % 18 == 12) {
            return true
        }
        val divisors = getDivisors(n)
        val divisorSum = divisors.stream().mapToInt { i: Int? -> i!! }.sum()
        //  divisor sum cannot be odd
        if (divisorSum % 2 == 1) {
            return false
        }
        // numbers where n is odd and the abundance is even are Zumkeller numbers
        val abundance = divisorSum - 2 * n
        if (n % 2 == 1 && abundance > 0 && abundance % 2 == 0) {
            return true
        }
        divisors.sort()
        val j = divisors.size - 1
        val sum = divisorSum / 2
        //  Largest divisor larger than sum - then cannot partition and not Zumkeller number
        return if (divisors[j] > sum) false else canPartition(j, divisors, sum, IntArray(2))
    }

    private fun canPartition(j: Int, divisors: List<Int>, sum: Int, buckets: IntArray): Boolean {
        if (j < 0) {
            return true
        }
        for (i in 0..1) {
            if (buckets[i] + divisors[j] <= sum) {
                buckets[i] += divisors[j]
                if (canPartition(j - 1, divisors, sum, buckets)) {
                    return true
                }
                buckets[i] -= divisors[j]
            }
            if (buckets[i] == 0) {
                break
            }
        }
        return false
    }

    private fun getDivisors(number: Int): MutableList<Int> {
        val divisors: MutableList<Int> = ArrayList()
        val sqrt = sqrt(number.toDouble()).toLong()
        for (i in 1..sqrt) {
            if (number % i == 0L) {
                divisors.add(i.toInt())
                val div = (number / i).toInt()
                if (div.toLong() != i) {
                    divisors.add(div)
                }
            }
        }
        return divisors
    }
}
