import "./math" for Int
import "./fmt" for Fmt

var limit = 1e6
var lowerLimit = 2500
var c = Int.primeSieve(limit - 1, false)
var erdos = []
var lastErdos = 0
var ec = 0
var i = 2
while (i < limit) {
    if (!c[i]) {
        var j = 1
        var fact = 1
        var found = true
        while (fact < i) {
            if (!c[i - fact]) {
                found = false
                break
            }
            j = j + 1
            fact = fact * j
        }
        if (found) {
            if (i < lowerLimit) erdos.add(i)
            lastErdos = i
            ec = ec + 1
        }
    }
    i = (i > 2) ? i + 2 : i + 1
}

Fmt.print("The $,d Erdős primes under $,d are:", erdos.count, lowerLimit)
Fmt.tprint("$6d", erdos, 10)
Fmt.print("\nThe $,r Erdős prime is $,d.", ec, lastErdos)
