val cache = new Array[BigInt](15000)
cache(0) = 1
val cacheNaive = scala.collection.mutable.Map[Tuple2[Int, Int], BigInt]()

def p(n: Int, k: Int): BigInt = cacheNaive.getOrElseUpdate((n, k), (n, k) match {
    case (n, 1) => 1
    case (n, k) if n < k => 0
    case (n, k) if n == k => 1
    case (n, k) =>
        if (k > n/2) p(n - 1, k - 1)
        else p(n - 1, k - 1) + p(n - k, k)
})

def partitions(n: Int) = (1 to n).map(p(n, _)).sum

def updateCache(n: Int, d: Int, k: Int) =
    if ((k & 1) == 1) cache(n) = cache(n) + cache(d)
    else cache(n) = cache(n) - cache(d)

def quickPartitions(n: Int): BigInt = {
    cache(n) = 0
    for (k <- 1 to n) {
        val d = n - k * (3 * k - 1) / 2
        if (d >= 0) {
            updateCache(n, d, k)

            val e = d - k
            if (e >= 0) {
                updateCache(n, e, k)
            }
        }
    }
    cache(n)
}

for (i <- 1 to 23) {
    for (j <- 1 to i) {
        print(f"${p(i, j)}%4d")
    }
    println
}
println(partitions(23))

for (i <- 1 until cache.length) {
    quickPartitions(i)
}
println(quickPartitions(123))
println(quickPartitions(1234))
println(quickPartitions(12345))
