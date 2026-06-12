import "./big" for BigInt

var endsWithOne = Fn.new { |n|
    var sum = 0
    while (true) {
        while (n > 0) {
            var digit = n % 10
            sum = sum + digit * digit
            n = (n/10).floor
        }
        if (sum == 1)  return true
        if (sum == 89) return false
        n = sum
        sum = 0
    }
}

var ks = [7, 8, 11, 14, 17]
for (k in ks) {
    var sums = List.filled(k * 81 + 1, 0)
    sums[0] = 1
    sums[1] = 0
    for (n in 1..k) {
        for (i in n*81..1) {
            for (j in 1..9) {
                var s = j * j
                if (s > i) break
                sums[i] = sums[i] + sums[i-s]
            }
        }
    }
    var count1 = BigInt.zero
    for (i in 1..k*81) if (endsWithOne.call(i)) count1 = count1 + sums[i]
    var limit = BigInt.ten.pow(k) - 1
    System.print("For k = %(k) in the range 1 to %(limit)")
    System.print("%(count1) numbers produce 1 and %(limit - count1) numbers produce 89\n")
}
