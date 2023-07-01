import "/math" for Int

var successivePrimes = Fn.new { |primes, diffs|
    var results = []
    var dl = diffs.count
    for (i in 0...primes.count-dl) {
        var group = List.filled(dl+1, 0)
        group[0] = primes[i]
        var outer = false
        for (j in i...i+dl) {
            var cont = false
            if (primes[j+1] - primes[j] != diffs[j-i]) {
                outer = true
                break
            }
            group[j-i+1] = primes[j+1]
        }
        if (!outer) results.add(group)
    }
    return results
}

var primes = Int.primeSieve(999999)
var diffsList = [ [2], [1], [2, 2], [2, 4], [4, 2], [6, 4, 2] ]
System.print("For primes less than 1,000,000:-\n")
for (diffs in diffsList) {
    System.print("  For differences of %(diffs) ->")
    var sp = successivePrimes.call(primes, diffs)
    var cont = false
    if (sp.count == 0) {
        System.print("    No groups found")
        cont = true
    }
    if (!cont) {
        System.print("    First group   =  %(sp[0])")
        System.print("    Last group    =  %(sp[-1])")
        System.print("    Number found  =  %(sp.count)\n")
    }
}
