import "./math" for Int, Nums
import "./fmt" for Fmt

// library method customized for this task
var divisors = Fn.new { |n|
    var divisors = []
    var i = 1
    var k = (n%2 == 0) ? 1 : 2
    while (i <= n.sqrt) {
        if (i > 1 && n%i == 0) {  // exclude 1 and n
            divisors.add(i)
            if (divisors.count > 2) break // not eligible if has > 2 divisors
            var j = (n/i).floor
            if (j != i) divisors.add(j)
        }
        i = i + k
    }
    return divisors
}

var limit = 500
var count = 0
var i = 1
System.print("Multiplicatively perfect numbers under %(limit):")
while (true) {
    var pd = (i != 1) ? divisors.call(i) : [1, 1]
    if (pd.count == 2 && pd[0] * pd[1] == i) {
        count = count + 1
        if (i < 500) {
            var pds = Fmt.swrite("$3d x $3d", pd[0], pd[1])
            Fmt.write("$3d  = $s   ", i, pds)
            if (count % 5 == 0) System.print()
        }
    }
    if (i == 499) System.print()
    if (i >= limit - 1) {
        var squares = Int.primeCount((limit - 1).sqrt.floor)
        var cubes   = Int.primeCount((limit - 1).cbrt.floor)
        var count2 = count + squares - cubes - 1
        Fmt.print("Counts under $,9d: MPNs = $,7d  Semi-primes = $,7d", limit, count, count2)
        if (limit == 5000000) return
        limit = limit * 10
    }
    i = i + 1
}
