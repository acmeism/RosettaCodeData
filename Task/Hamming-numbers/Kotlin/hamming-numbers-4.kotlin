import java.math.BigInteger as BI

data class LazyList<T>(val head: T, val lztail: Lazy<LazyList<T>?>) {
    fun toSequence() = generateSequence(this) { it.lztail.value }
            .map { it.head }
}

fun hamming(): LazyList<BI> {
    fun merge(s1: LazyList<BI>, s2: LazyList<BI>): LazyList<BI> {
        val s1v = s1.head; val s2v = s2.head
        if (s1v < s2v) {
            return LazyList(s1v, lazy({->merge(s1.lztail.value!!, s2)}))
        } else {
            return LazyList(s2v, lazy({->merge(s1, s2.lztail.value!!)}))
        }
    }
    fun llmult(m: BI, s: LazyList<BI>): LazyList<BI> {
        fun llmlt(ss: LazyList<BI>): LazyList<BI> {
            return LazyList(m * ss.head, lazy({->llmlt(ss.lztail.value!!)}))
        }
        return llmlt(s)
    }
    fun u(s: LazyList<BI>?, n: Long): LazyList<BI> {
        var r: LazyList<BI>? = null // mutable nullable so can do the below
        if (s == null) { // recursively referenced variables are ugly!!!
            r = llmult(BI.valueOf(n), LazyList(BI.valueOf(1), lazy{ -> r }))
        } else { // recursively referenced variables only work with lazy
            r = merge(s, llmult(BI.valueOf(n), // or a loop race limit
                                LazyList(BI.valueOf(1), lazy{ -> r })))
        }
        return r
    }
    val prms = arrayOf(5L, 3L, 2L)
    val thunk = {->prms.fold<Long,LazyList<BI>?>(null, {s, n -> u(s,n)})!!}
    return LazyList(BI.valueOf(1), lazy(thunk))
}

fun main(args: Array<String>) {
	tailrec fun nth(n: Int, h: LazyList<BI>): BI =
		if (n > 1) { nth(n - 1, h.lztail.value!!) }
		else { h.head } // non-generic faster: boxing optimized away
	println(hamming().toSequence().take(20).toList())
	println(nth(1691, hamming()))
	val strt = System.currentTimeMillis()
	println(nth(1000000, hamming()))
	val stop = System.currentTimeMillis()
	println("Took ${stop - strt} milliseconds for the last.")
}
