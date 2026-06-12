import "./math" for Int
import "./fmt" for Conv, Fmt
import "./iterate" for Stepped

var start = System.clock

var primes = Int.primeSieve(3000)

var countBits = Fn.new { |n| Conv.bin(n).count { |c| c == "1" } }

var cubesBefore = Fn.new { |n|
    var r = 0
    var xpm = true
    var pm = []
    for (i in 1..n.cbrt.floor) {
        var p3 = primes[i-1].pow(3)
        if (p3 > n) break
        var k = (n/p3).floor
        for (mask in Stepped.ascend(1..2.pow(pm.count)-1)) {
            var m = mask
            var mi = 0
            var bc = countBits.call(mask)
            var kpm = p3
            while (m != 0) {
                mi = mi + 1
                if (m % 2 == 1) kpm = kpm * pm[mi-1]
                m = (m/2).floor
            }
            if (kpm > n) {
                if (bc == 1) {
                    xpm = false
                    pm = pm[0...mi-1]
                    break
                }
            } else {
                var l = (n/kpm).floor
                if (bc % 2 == 1) {
                    k = k - l
                } else {
                    k = k + l
                }
            }
        }
        r = r + k
        if (xpm) pm.add(p3)
    }
    return r
}

var cubeFree = Fn.new { |nth|
    var lo = nth
    var hi = lo * 2
    var mid
    var cb
    var k
    while (hi - cubesBefore.call(hi) < nth) {
        lo = hi
        hi = lo * 2
    }
    while (true) {
        mid = ((lo + hi)/2).floor
        cb = cubesBefore.call(mid)
        k = mid - cb
        if (k == nth) {
            while (cubesBefore.call(mid-1) != cb) {
                mid = mid - 1
                cb = cb - 1
            }
            break
        } else if (k < nth) {
            lo = mid
        } else {
            hi = mid
        }
    }
    return mid
}

var a370833 = Fn.new { |n|
    if (n == 1) return [1, 1]
    var nth = cubeFree.call(n)
    return [Int.primeFactors(nth)[-1], nth]
}

System.print("First 100 terms of a[n]:")
Fmt.tprint("$3d", (1..100).map { |i| a370833.call(i)[0] }, 10)
System.print()
var n = 1000
while (n <= 1e10) {
    var res = a370833.call(n)
    Fmt.print("The $,r term of a[n] is $,d for cubefree number $,d.", n, res[0], res[1])
    n = n * 10
}
System.print("\nTook %(System.clock - start) seconds.")
