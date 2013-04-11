def radixSort = { final radixExponent, list ->
    def fromBuckets = new TreeMap([0:list])
    def toBuckets = new TreeMap()
    final radix = 2**radixExponent
    final mask = radix - 1
    final radixDigitSize = (int)Math.ceil(64/radixExponent)
    final digitWidth = radixExponent
    (0..<radixDigitSize).each { radixDigit ->
        fromBuckets.values().findAll { it != null }.flatten().each {
            print '.'
            long bucketNumber = (long)((((long)it) >>> digitWidth*radixDigit) & mask)
            toBuckets[bucketNumber] = toBuckets[bucketNumber] ?: []
            toBuckets[bucketNumber] << it
        }
        (fromBuckets, toBuckets) = [toBuckets, fromBuckets]
        toBuckets.clear()
    }
    final overflow = 2**(63 % radixExponent)
    final pos = {it < overflow}
    final neg = {it >= overflow}
    final keys = fromBuckets.keySet()
    final twosComplIndx = [] + (keys.findAll(neg)) + (keys.findAll(pos))
    twosComplIndx.collect { fromBuckets[it] }.findAll { it != null }.flatten()
}
