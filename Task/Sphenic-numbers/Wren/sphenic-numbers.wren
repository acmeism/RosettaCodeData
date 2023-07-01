import "./math" for Int
import "./seq" for Seq
import "./fmt" for Fmt

var limit = 1000000
var limit2 = limit.cbrt.floor // first prime can't be more than this
var primes = Int.primeSieve((limit/6).floor)
var pc = primes.count
var sphenic = []
System.print("Sphenic numbers less than 1,000:")
for (i in 0...pc-2) {
    if (primes[i] > limit2) break
    for (j in i+1...pc-1) {
        var prod = primes[i] * primes[j]
        if (prod * primes[j + 1] >= limit) break
        for (k in j+1...pc) {
            var res = prod * primes[k]
            if (res >= limit) break
            sphenic.add(res)
        }
    }
}
sphenic.sort()
Fmt.tprint("$3d", Seq.takeWhile(sphenic) { |s| s < 1000 }, 15)
System.print("\nSphenic triplets less than 10,000:")
var triplets = []
for (i in 0...sphenic.count-2) {
    var s = sphenic[i]
    if (sphenic[i+1] == s + 1 && sphenic[i+2] == s + 2) {
        triplets.add([s, s + 1, s + 2])
    }
}
Fmt.tprint("$18n", Seq.takeWhile(triplets) { |t| t[2] < 10000 }, 3)
Fmt.print("\nThere are $,d sphenic numbers less than 1,000,000.", sphenic.count)
Fmt.print("There are $,d sphenic triplets less than 1,000,000.", triplets.count)
var s = sphenic[199999]
Fmt.print("The 200,000th sphenic number is $,d ($s).", s, Int.primeFactors(s).join("*"))
Fmt.print("The 5,000th sphenic triplet is $n.", triplets[4999])
