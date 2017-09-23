// version 1.1.3
// compile with -Xcoroutines=enable flag from command line

import kotlin.coroutines.experimental.*

typealias CFGenerator = (Pair<Int, Int>) -> Sequence<Int>

data class CFData(
    val str: String,
    val ng: IntArray,
    val r: Pair<Int,Int>,
    val gen: CFGenerator
)

fun r2cf(frac: Pair<Int, Int>) =
    buildSequence {
        var num = frac.first
        var den = frac.second
        while (Math.abs(den) != 0) {
            val div = num / den
            val rem = num % den
            num = den
            den = rem
            yield(div)
        }
    }

fun d2cf(d: Double) =
    buildSequence {
        var dd  = d
        while (true) {
            val div = Math.floor(dd)
            val rem = dd - div
            yield(div.toInt())
            if (rem == 0.0) break
            dd = 1.0 / rem
        }
    }

@Suppress("UNUSED_PARAMETER")
fun root2(dummy: Pair<Int, Int>) =
    buildSequence {
        yield(1)
        while (true) yield(2)
    }

@Suppress("UNUSED_PARAMETER")
fun recipRoot2(dummy: Pair<Int, Int>) =
    buildSequence {
       yield(0)
       yield(1)
       while (true) yield(2)
    }

class NG(var a1: Int, var a: Int, var b1: Int, var b: Int) {

    fun ingress(n: Int) {
        var t = a
        a = a1
        a1 = t + a1 * n
        t = b
        b = b1
        b1 = t + b1 * n
    }

    fun egress(): Int {
        val n = a / b
        var t = a
        a = b
        b = t - b * n
        t = a1
        a1 = b1
        b1 = t - b1 * n
        return n
    }

    val needTerm get() = (b == 0 || b1 == 0) || ((a / b) != (a1 / b1))

    val egressDone: Int
        get() {
            if (needTerm) {
                a = a1
                b = b1
            }
            return egress()
        }

    val done get() = b == 0 &&  b1 == 0
}

fun main(args: Array<String>) {
    val data = listOf(
        CFData("[1;5,2] + 1/2        ", intArrayOf(2, 1, 0, 2), 13 to 11, ::r2cf),
        CFData("[3;7] + 1/2          ", intArrayOf(2, 1, 0, 2), 22 to 7,  ::r2cf),
        CFData("[3;7] divided by 4   ", intArrayOf(1, 0, 0, 4), 22 to 7,  ::r2cf),
        CFData("sqrt(2)              ", intArrayOf(0, 1, 1, 0),  0 to 0,  ::recipRoot2),
        CFData("1 / sqrt(2)          ", intArrayOf(0, 1, 1, 0),  0 to 0,  ::root2),
        CFData("(1 + sqrt(2)) / 2    ", intArrayOf(1, 1, 0, 2),  0 to 0,  ::root2),
        CFData("(1 + 1 / sqrt(2)) / 2", intArrayOf(1, 1, 0, 2),  0 to 0,  ::recipRoot2)
    )
    println("Produced by NG class:")
    for ((str, ng, r, gen) in data) {
        print("$str -> ")
        val (a1, a, b1, b) = ng
        val op = NG(a1, a, b1, b)
        for (n in gen(r).take(20)) {
            if (!op.needTerm) print(" ${op.egress()} ")
            op.ingress(n)
        }
        while (true) {
            print(" ${op.egressDone} ")
            if (op.done) break
        }
        println()
    }
    println("\nProduced by direct calculation:")
    val data2 = listOf(
        Pair("(1 + sqrt(2)) / 2    ", (1 + Math.sqrt(2.0)) / 2),
        Pair("(1 + 1 / sqrt(2)) / 2", (1 + 1 / Math.sqrt(2.0)) / 2)
    )
    for ((str, d) in data2) {
        println("$str ->  ${d2cf(d).take(20).joinToString("  ")}")
    }
}
