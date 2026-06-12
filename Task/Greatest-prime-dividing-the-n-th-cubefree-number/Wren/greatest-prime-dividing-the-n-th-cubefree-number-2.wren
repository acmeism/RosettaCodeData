import "./math" for Int
//import "./array" for BitArray
import "./fmt" for Fmt

var cubeFreeSieve = Fn.new { |n|
    var cubeFree = List.filled(n+1, true) // or BitArray.new(n+1, true)
    var primes = Int.primeSieve(n.cbrt.ceil)
    for (p in primes) {
        var p3 = p * p * p
        var k = 1
        while (p3 * k <= n) {
            cubeFree[p3 * k] = false
            k = k + 1
        }
    }
    return cubeFree
}

var al = [1]
var count = 1
var i = 2
var lim1 = 100
var lim2 = 1000
var max = 1e9
var cubeFree = cubeFreeSieve.call(max * 1.25)
while (count < max) {
    if (cubeFree[i]) {
        count = count + 1
        if (count <= lim1) {
            var factors = Int.primeFactors(i)
            al.add(factors[-1])
            if (count == lim1) {
                System.print("First %(lim1) terms of a[n]:")
                Fmt.tprint("$3d", al, 10)
            }
        } else if (count == lim2) {
            var factors = Int.primeFactors(i)
            Fmt.print("\nThe $,r term of a[n] is $,d.", count, factors[-1])
            lim2 = lim2 * 10
        }
    }
    i = i + 1
}
