import "./fmt" for Fmt

var ludic = Fn.new { |n, max|
    var maxInt32 = 2.pow(31) - 1
    if (max > 0 && n < 0) n = maxInt32
    if (n < 1) return []
    if (max < 0) max = maxInt32
    var sieve = List.filled(10760, 0)
    sieve[0] = 1
    sieve[1] = 2
    if (n > 2) {
        var j = 3
        for (i in 2...sieve.count) {
            sieve[i] = j
            j = j + 2
        }
        for (k in 2...n) {
            var l = sieve[k]
            if (l >= max) {
                n = k
                break
            }
            var i = l
            l = l - 1
            var last = k + i - 1
            var j = k + i + 1
            while (j < sieve.count) {
                last = k + i
                sieve[last] = sieve[j]
                if (i%l == 0) j = j + 1
                i = i + 1
                j = j + 1
            }
            if (last < sieve.count-1) sieve = sieve[0..last]
        }
    }
    if (n > sieve.count) Fiber.abort("Program error.")
    return sieve[0...n]
}

var has = Fn.new { |x, v|
    var i = 0
    while (i < x.count && x[i] <= v) {
        if (x[i] == v) return true
        i = i + 1
    }
    return false
}

System.print("First 25: %(ludic.call(25, -1))")
System.print("Number of Ludics below 1000: %(ludic.call(-1, 1000).count)")
System.print("Ludics 2000 to 2005: %(ludic.call(2005, -1)[1999..-1])")
System.print("Triplets below 250:")
var x = ludic.call(-1, 250)
var i = 0
var triples = []
for (v in x.take(x.count-2)) {
    if (has.call(x[i+1..-1], v+2) && has.call(x[i+2..-1], v+6)) {
        triples.add([v, v+2, v+6])
    }
    i = i + 1
}
System.print(triples)
