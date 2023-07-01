var factors = []
var inc = [4, 2, 4, 2, 4, 6, 2, 6]

// Assumes n is even with exactly one factor of 2.
// Empties 'factors' if any other prime factor is repeated.
var primeFactors = Fn.new { |n|
    factors.clear()
    var last = 2
    factors.add(2)
    n = (n/2).truncate
    while (n%3 == 0) {
        if (last == 3) {
            factors.clear()
            return
        }
        last = 3
        factors.add(3)
        n = (n/3).truncate
    }
    while (n%5 == 0) {
        if (last == 5) {
            factors.clear()
            return
        }
        last = 5
        factors.add(5)
        n = (n/5).truncate
    }
    var k = 7
    var i = 0
    while (k * k <= n) {
        if (n%k == 0) {
            if (last == k) {
                factors.clear()
                return
            }
            last = k
            factors.add(k)
            n = (n/k).truncate
        } else {
            k = k + inc[i]
            i = (i + 1) % 8
        }
    }
    if (n > 1) factors.add(n)
}

var limit = 4
var giuga = []
var n = 6 // can't be 2 or 4
while (giuga.count < limit) {
    primeFactors.call(n)
    // can't be prime or semi-prime
    if (factors.count > 2 && factors.all { |f| (n/f - 1) % f == 0 }) {
        giuga.add(n)
    }
    n = n + 4 // can't be divisible by 4
}
System.print("The first %(limit) Giuga numbers are:")
System.print(giuga)
