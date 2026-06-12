import "./math" for Int
import "./big" for BigInt
import "./fmt" for Fmt

var boustrophedon1000 = Fn.new { |a|
    var k = a.count
    var cache = List.filled(k, null)
    for (i in 0...k) {
        cache[i] = List.filled(k, null)
        for (j in 0...k) cache[i][j] = BigInt.zero
    }
    var T
    T = Fn.new { |k, n|
        if (n == 0) return a[k]
        if (cache[k][n] > BigInt.zero) return cache[k][n]
        return cache[k][n] = T.call(k, n-1) + T.call(k-1, k-n)
    }
    return T.call(999, 999)
}

System.print("1 followed by 0's:")
var a = ([1] + [0] * 999).map { |i| BigInt.new(i) }.toList
var bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)

System.print("\nAll 1's:")
a = ([1] * 1000).map { |i| BigInt.new(i) }.toList
bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)

System.print("\nAlternating 1, -1")
a  = ([1, -1] * 500).map { |i| BigInt.new(i) }.toList
bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)

System.print("\nPrimes:")
a = Int.primeSieve(8000)[0..999].map { |i| BigInt.new(i) }.toList
bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)

System.print("\nFibonacci numbers:")
a[0] = BigInt.one // start from fib(1)
a[1] = BigInt.one
for (i in 2..999) a[i] = a[i-1] + a[i-2]
bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)

System.print("\nFactorials:")
a[0] = BigInt.one
for (i in 1..999) a[i] = a[i-1] * i
bs = boustrophedon1000.call(a).toString
Fmt.print("1000th term: $20a ($d digits)", bs, bs.count)
