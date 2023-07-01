import "./math" for Int

var erdosNicolas = Fn.new { |n|
    var divisors = Int.properDivisors(n) // excludes n itself
    var dc = divisors.count
    if (dc < 3) return 0
    var sum = divisors[0] + divisors[1]
    for (i in 2...dc-1) {
        sum = sum + divisors[i]
        if (sum == n) return i + 1
        if (sum > n)  break
    }
    return 0
}

var limit = 8
var n = 2
var count = 0
while (true) {
    var k = erdosNicolas.call(n)
    if (k > 0) {
        System.print("%(n) from %(k)")
        count = count + 1
        if (count == limit) return
    }
    n = n + 2
}
