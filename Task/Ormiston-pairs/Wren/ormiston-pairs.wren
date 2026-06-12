import "./math" for Int
import "./fmt" for Fmt

var limit = 1e9
var primes = Int.primeSieve(limit)
var orm30 = []
var j = 1e5
var count = 0
var counts = []
for (i in 0...primes.count-1) {
    var p1 = primes[i]
    var p2 = primes[i+1]
    if ((p2 - p1) % 18 != 0) continue
    var key1 = 1
    for (dig in Int.digits(p1)) key1 = key1 * primes[dig]
    var key2 = 1
    for (dig in Int.digits(p2)) key2 = key2 * primes[dig]
    if (key1 == key2) {
        if (count < 30) orm30.add([p1, p2])
        if (p1 >= j) {
            counts.add(count)
            j = j * 10
        }
        count = count + 1
    }
}
counts.add(count)
System.print("First 30 Ormiston pairs:")
Fmt.tprint("[$,6d] ", orm30, 3)
System.print()
j = 1e5
for (i in 0...counts.count) {
    Fmt.print("$,d Ormiston pairs before $,d",  counts[i], j)
    j = j * 10
}
