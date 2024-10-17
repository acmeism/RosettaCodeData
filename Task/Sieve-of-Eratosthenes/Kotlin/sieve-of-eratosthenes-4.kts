fun primesOdds(rng: Int): Iterable<Int> {
    val topi = (rng - 3) / 2 //convert to nearest index
    val size = topi / 32 + 1 //word size to include index
    val sqrtndx = (Math.sqrt(rng.toDouble()).toInt() - 3) / 2
    val cmpsts = IntArray(size)
    fun is_p(i: Int) = cmpsts[i shr 5] and (1 shl (i and 0x1F)) == 0
    fun cull(i: Int) { cmpsts[i shr 5] = cmpsts[i shr 5] or (1 shl (i and 0x1F)) }
    fun iseq(high: Int, low: Int = 0, stp: Int = 1) =
            Sequence { (low .. high step(stp)).iterator() }
    fun cullp(p: Int) = iseq(topi, (p * p - 3) / 2, p).forEach { cull(it) }
    iseq(sqrtndx).filter { is_p(it) }.forEach { cullp(it + it + 3) }
    fun i2p(i: Int) = if (i < 0) 2 else i + i + 3
    val oseq = iseq(topi, -1).filter { it < 0 || is_p(it) }.map { i2p(it) }
    return Iterable { -> oseq.iterator() }
}
