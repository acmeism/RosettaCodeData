import "./math" for Int
import "./fmt" for Fmt

var limit = 1e10
var primes = Int.segmentedSieve(limit, 128 * 1024)
var orm25 = []
var j = limit/10
var count = 0
var counts = []
for (i in 0...primes.count-2) {
    var p1 = primes[i]
    var p2 = primes[i+1]
    var p3 = primes[i+2]
    if ((p2 - p1) % 18 != 0 || (p3 - p2) % 18 != 0) continue
    var key1 = 1
    for (dig in Int.digits(p1)) key1 = key1 * primes[dig]
    var key2 = 1
    for (dig in Int.digits(p2)) key2 = key2 * primes[dig]
    if (key1 != key2) continue
    var key3 = 1
    for (dig in Int.digits(p3)) key3 = key3 * primes[dig]
    if (key2 == key3) {
        if (count < 25) orm25.add(p1)
        if (p1 >= j) {
            counts.add(count)
            j = j * 10
        }
        count = count + 1
    }
}
counts.add(count)
System.print("Smallest members of first 25 Ormiston triples:")
Fmt.tprint("$,10d ", orm25, 5)
System.print()
j = limit/10
for (i in 0...counts.count) {
    Fmt.print("$,d Ormiston triples before $,d",  counts[i], j)
    j = j * 10
    System.print()
}
