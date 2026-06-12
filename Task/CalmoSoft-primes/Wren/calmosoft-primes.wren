import "./math" for Int, Nums
import "./fmt"for Fmt

var max = 50000000
var primes = Int.primeSieve(max)

var calmoPrimes = Fn.new { |limit|
    var pc = (limit < max) ? primes.count { |p| p <= limit } : primes.count
    var sum = (limit < max) ? Nums.sum(primes.take(pc)) : Nums.sum(primes)
    var longest = 0
    var sIndices = []
    var eIndices = []
    var sums = []
    for (i in 0...pc) {
        if (pc - i < longest) break
        if (i > 0) sum = sum - primes[i-1]
        var isEven = (i == 0)
        var sum2 = sum
        for (j in pc-1..i) {
            var temp = j - i + 1
            if (temp < longest) break
            if (j < pc - 1) sum2 = sum2 - primes[j+1]
            if ((temp % 2) == 0 != isEven) continue
            if (Int.isPrime2(sum2)) {
                if (temp > longest) {
                    longest = temp
                    sIndices = [i]
                    eIndices = [j]
                    sums = [sum2]
                } else {
                    sIndices.add(i)
                    eIndices.add(j)
                    sums.add(sum2)
                }
                break
            }
        }
    }
    return [longest, sIndices, eIndices, sums]
}

for (limit in [100, 250, 5000, 10000, 500000, 50000000]) {
    var res = calmoPrimes.call(limit)
    var longest = res[0]
    var sIndices = res[1]
    var eIndices = res[2]
    var sums = res[3]
    Fmt.print("For primes up to $,d the longest sequence(s) of CalmoSoft primes", limit)
    Fmt.print("having a length of $,d is/are:\n", longest)
    for (i in 0...sIndices.count) {
        var cp = primes[sIndices[i]..eIndices[i]]
        var cps = Fmt.va("d", 1, cp, 0, " + ", "", "", 6, "..")
        Fmt.print("$s = $,d", cps, sums[i])
    }
    System.print()
}
