// version 1.2.51

import java.util.Random

val rand = Random()

fun <T> SOfNCreator(n: Int): (T) -> List<T> {
    val sample = ArrayList<T>(n)
    var i = 0
    return {
        if (++i <= n)
            sample.add(it)
        else if (rand.nextInt(i) < n)
            sample[rand.nextInt(n)] = it
        sample
    }
}

fun main(args: Array<String>) {
    val bin = IntArray(10)
    (1..100_000).forEach {
        val sOfn = SOfNCreator<Int>(3)
        for (d in 0..8) sOfn(d)
        for (s in sOfn(9)) bin[s]++
    }
    println(bin.contentToString())
}
