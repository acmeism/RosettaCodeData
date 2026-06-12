import "./math" for Int, Nums
import "./fmt" for Fmt

// Uses the first definition and recursion to generate the sequences.
var moreMultiples
moreMultiples = Fn.new { |toSeq, fromSeq|
    var oneMores = []
    for (i in fromSeq) {
        if (i > toSeq[-1] && i%toSeq[-1] == 0) oneMores.add(toSeq + [i])
    }
    if (oneMores.isEmpty) return []
    for (i in 0...oneMores.count) {
        oneMores.addAll(moreMultiples.call(oneMores[i], fromSeq))
    }
    return oneMores
}

var cache = {}

var erdosFactorCount
erdosFactorCount = Fn.new { |n|
    var divs = Int.properDivisors(n)
    divs.removeAt(0)
    var sum = 0
    for (d in divs) {
        var t = (n/d).floor
        if (!cache.containsKey(t)) cache[t] = erdosFactorCount.call(t)
        sum = sum + cache[t]
    }
    return sum + 1
}

var listing = moreMultiples.call([1], Int.properDivisors(48))
listing.sort { |l1, l2|
    var c1 = l1.count
    var c2 = l2.count
    for (i in 1...c1.min(c2)) {
        if (l1[i] < l2[i]) return true
        if (l1[i] > l2[i]) return false
    }
    if (c1 < c2) return true
    return false
}
listing.each { |l| l.add(48) }
listing.add([1, 48])
System.print("%(listing.count) sequences using first definition:")
Fmt.tprint("$-21n", listing, 4)

System.print("\n%(listing.count) sequences using second definition:")
var listing2 = []
for (i in 0...listing.count) {
    var seq = listing[i]
    if (seq[-1] != 48) seq.add(48)
    var seq2 = (1...seq.count).map { |i| (seq[i]/seq[i-1]).floor }.toList
    listing2.add(seq2)
}
Fmt.tprint("$-17n", listing2, 4)

System.print("\nOEIS A163272:")
var n = 4
var fpns = [0, 1]
while (fpns.count < 9) {
    if (erdosFactorCount.call(n) == n) fpns.add(n)
    n = n + 4
}
System.print(fpns)
