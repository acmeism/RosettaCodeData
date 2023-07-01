import "./psieve" for Primes
import "./math" for Int
import "./fmt" for Fmt

var limit = 1e10
var digitPrimes = Int.primeSieve(30)
var it = Primes.iter()
var orm25 = []
var j = limit/10
var count = 0
var counts = []
var p1 = it.next
var p2 = it.next
var p3 = it.next
while (true) {
    p1 = p2
    p2 = p3
    p3 = it.next
    if ((p2 - p1) % 18 != 0 || (p3 - p2) % 18 != 0) continue
    var key1 = 1
    for (dig in Int.digits(p1)) key1 = key1 * digitPrimes[dig]
    var key2 = 1
    for (dig in Int.digits(p2)) key2 = key2 * digitPrimes[dig]
    if (key1 != key2) continue
    var key3 = 1
    for (dig in Int.digits(p3)) key3 = key3 * digitPrimes[dig]
    if (key2 == key3) {
        if (count < 25) orm25.add(p1)
        if (p1 >= j) {
            counts.add(count)
            if (j == limit) break
            j = j * 10
        }
        count = count + 1
    }
}
System.print("Smallest members of first 25 Ormiston triples:")
Fmt.tprint("$,10d ", orm25, 5)
System.print()
j = limit/10
for (i in 0...counts.count) {
    Fmt.print("$,d Ormiston triples before $,d",  counts[i], j)
    j = j * 10
    System.print()
}
