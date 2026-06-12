import "./math" for Int

var boustrophedon = Fn.new { |a|
    var k = a.count
    var cache = List.filled(k, null)
    for (i in 0...k) cache[i] = List.filled(k, 0)
    var b = List.filled(k, 0)
    b[0] = a[0]
    var T
    T = Fn.new { |k, n|
        if (n == 0) return a[k]
        if (cache[k][n] > 0) return cache[k][n]
        return cache[k][n] = T.call(k, n-1) + T.call(k-1, k-n)
    }
    for (n in 1...k) b[n] = T.call(n, n)
    return b
}

System.print("1 followed by 0's:")
var a = [1] + ([0] * 14)
System.print(boustrophedon.call(a))

System.print("\nAll 1's:")
a = [1] * 15
System.print(boustrophedon.call(a))

System.print("\nAlternating 1, -1")
a  = [1, -1] * 7 + [1]
System.print(boustrophedon.call(a))

System.print("\nPrimes:")
a = Int.primeSieve(200)[0..14]
System.print(boustrophedon.call(a))

System.print("\nFibonacci numbers:")
a[0] = 1 // start from fib(1)
a[1] = 1
for (i in 2..14) a[i] = a[i-1] + a[i-2]
System.print(boustrophedon.call(a))

System.print("\nFactorials:")
a[0] = 1
for (i in 1..14) a[i] = a[i-1] * i
System.print(boustrophedon.call(a))
