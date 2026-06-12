import "./seq" for Lst
import "./fmt" for Fmt

var ulam = Fn.new { |n|
    var ulams = [1, 2]
    var sieve = [1, 1]
    var u = 2
    while (ulams.count < n) {
        var s = u + ulams[-2]
        sieve = sieve + ([0] * (s - sieve.count))
        for (i in 1..ulams.count - 1) {
            var v = u + ulams[i-1] - 1
            sieve[v] = sieve[v] + 1
        }
        u = Lst.indexOf(sieve, 1, u) + 1
        ulams.add(u)
    }
    return ulams[n-1]
}

var start = System.clock
for (p in 0..4) {
    var n = 10.pow(p)
    Fmt.print("The $,r Ulam number is $,d", n, ulam.call(n))
}
System.print("\nTook %(System.clock - start) seconds.")
