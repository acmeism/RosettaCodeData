abstract class Catalan {
    abstract operator fun invoke(n: Int) : Double

    protected val m = mutableMapOf(0 to 1.0)
}

object CatalanI : Catalan() {
    override fun invoke(n: Int): Double {
        if (n !in m)
            m[n] = Math.round(fact(2 * n) / (fact(n + 1) * fact(n))).toDouble()
        return m[n]!!
    }

    private fun fact(n: Int): Double {
        if (n in facts)
            return facts[n]!!
        val f = n * fact(n -1)
        facts[n] = f
        return f
    }

    private val facts = mutableMapOf(0 to 1.0, 1 to 1.0, 2 to 2.0)
}

object CatalanR1 : Catalan() {
    override fun invoke(n: Int): Double {
        if (n in m)
            return m[n]!!

        var sum = 0.0
        for (i in 0..n - 1)
            sum += invoke(i) * invoke(n - 1 - i)
        sum = Math.round(sum).toDouble()
        m[n] = sum
        return sum
    }
}

object CatalanR2 : Catalan() {
    override fun invoke(n: Int): Double {
        if (n !in m)
            m[n] = Math.round(2.0 * (2 * (n - 1) + 1) / (n + 1) * invoke(n - 1)).toDouble()
        return m[n]!!
    }
}

fun main(args: Array<String>) {
    val c = arrayOf(CatalanI, CatalanR1, CatalanR2)
    for(i in 0..15) {
        c.forEach { print("%9d".format(it(i).toLong())) }
        println()
    }
}
