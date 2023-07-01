import "/math" for Int, Nums
import "/iterate" for Stepped

var semiperfect // recursive
semiperfect = Fn.new { |n, divs|
    var le = divs.count
    if (le == 0) return false
    var h = divs[0]
    if (n == h) return true
    if (le == 1) return false
    var t = divs[1..-1]
    if (n < h) return semiperfect.call(n, t)
    return semiperfect.call(n-h, t) || semiperfect.call(n, t)
}

var sieve = Fn.new { |limit|
    // 'false' denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    var w = List.filled(limit, false)
    for (j in Stepped.new(6...limit, 6)) w[j] = true // eliminate multiples of 3
    for (i in Stepped.new(2...limit, 2)) {
        if (!w[i]) {
            var divs = Int.properDivisors(i)
            var sum = Nums.sum(divs)
            if (sum <= i) {
                w[i] = true
            } else if (semiperfect.call(sum-i, divs)) {
                for (j in Stepped.new(i...limit, i)) w[j] = true
            }
        }
    }
    return w
}

var start = System.clock
var limit = 16313
var w = sieve.call(limit)
var count = 0
var max = 25
System.print("The first 25 weird numbers are:")
var n = 2
while (count < max) {
    if (!w[n]) {
        System.write("%(n) ")
        count = count + 1
    }
    n = n + 2
}
System.print()
System.print("\nTook %(((System.clock-start)*1000).round) milliseconds")
