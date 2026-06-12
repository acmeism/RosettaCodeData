var reverse = Fn.new { |n|
    var r = 0
    while (n > 0) {
        r = n%10 + r*10
        n = (n/10).floor
    }
    return r
}

var pow = 10
for (n in 2..7) {
    var low = pow * 9
    pow = pow * 10
    var high = pow - 1
    System.write("Largest palindromic product of two %(n)-digit integers: ")
    var nextN = false
    for (i in high..low) {
        var j = reverse.call(i)
        var p = i * pow + j
        // k can't be even nor end in 5 to produce a product ending in 9
        var k = high
        while (k > low) {
            if (k % 10 != 5) {
                var l = p / k
                if (l > high) break
                if (p % k == 0) {
                    System.print("%(k) x %(l) = %(p)")
                    nextN = true
                    break
                }
            }
            k = k - 2
        }
        if (nextN) break
    }
}
