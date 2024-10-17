fun primesHM(): Sequence<Int> = sequence {
    yield(2)
    fun oddprms(): Sequence<Int> = sequence {
        yield(3); yield(5) // need at least 2 for initialization
        val hm = HashMap<Int,Int>()
        hm.put(9, 6)
        val bps = oddprms().iterator(); bps.next(); bps.next() // skip past 5
        yieldAll(generateSequence(SieveState(7, 5, 25)) {
            ss ->
                var n = ss.n; var q = ss.q
                n += 2
                while ( n >= q || hm.containsKey(n)) {
                    if (n >= q) {
                        val inc = ss.bp shl 1
                        hm.put(n + inc, inc)
                        val bp = bps.next(); ss.bp = bp; q = bp * bp
                    }
                    else {
                        val inc = hm.remove(n)!!
                        var next = n + inc
                        while (hm.containsKey(next)) {
                            next += inc
                        }
                        hm.put(next, inc)
                    }
                    n += 2
                }
                ss.n = n; ss.q = q
                ss
        }.map { it.n })
    }
    yieldAll(oddprms())
}
