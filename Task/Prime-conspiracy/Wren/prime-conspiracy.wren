import "/fmt" for Fmt
import "/math" for Int
import "/sort" for Sort

var reportTransitions = Fn.new { |transMap, num|
    var keys = transMap.keys.toList
    Sort.quick(keys)
    System.print("First %(Fmt.dc(0, num)) primes. Transitions prime \% 10 -> next-prime \% 10.")
    for (key in keys) {
        var count = transMap[key]
        var freq = count / num * 100
        System.write("%((key/10).floor) -> %(key%10)  count: %(Fmt.dc(8, count))")
        System.print("  frequency: %(Fmt.f(4, freq, 2))\%")
    }
    System.print()
}

// sieve up to the 10 millionth prime
var start = System.clock
var sieved = Int.primeSieve(179424673)
var transMap = {}
var i = 2 // last digit of first prime (2)
var n = 1 // index of next prime (3) in sieved
for (num in [1e4, 1e5, 1e6, 1e7]) {
    while(n < num) {
        var p = sieved[n]
        // count transition of i -> j
        var j = p % 10
        var k = i*10 + j
        var t = transMap[k]
        if (!t) {
            transMap[k] = 1
        } else {
            transMap[k] = t + 1
        }
        i = j
        n = n + 1
    }
    reportTransitions.call(transMap, n)
}
System.print("Took %(System.clock - start) seconds.")
