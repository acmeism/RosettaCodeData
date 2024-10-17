// version 1.2.51

import java.util.Random

val rand = Random()

class SOfN<T>(val n: Int) {
    private val sample = ArrayList<T>(n)
    private var i = 0

    fun process(item: T): List<T> {
        if (++i <= n)
            sample.add(item)
        else if (rand.nextInt(i) < n)
            sample[rand.nextInt(n)] = item
        return sample
    }
}

fun main(args: Array<String>) {
    val bin = IntArray(10)
    (1..100_000).forEach {
        val sOfn = SOfN<Int>(3)
        for (d in 0..8) sOfn.process(d)
        for (s in sOfn.process(9)) bin[s]++
    }
    println(bin.contentToString())
}
