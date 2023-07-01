var endsWith89 = Fn.new { |n|
    var digit = 0
    var sum = 0
    while (true) {
        while (n > 0) {
            digit = n % 10
            sum = sum + digit*digit
            n = (n/10).floor
        }
        if (sum == 89) return true
        if (sum == 1) return false
        n = sum
        sum = 0
    }
}

var start = System.clock
var sums = List.filled(8*81 + 1, 0)
sums[0] = 1
sums[1] = 0
var s = 0
for (n in 1..8) {
    for (i in n*81..1) {
        for (j in 1..9) {
            s = j * j
            if (s > i) break
            sums[i] = sums[i] + sums[i-s]
        }
    }
    if (n == 8) {
        var count89 = 0
        for (i in 1..n*81) {
            if (endsWith89.call(i)) count89 = count89 + sums[i]
        }
        System.print("There are %(count89) numbers from 1 to 100 million ending with 89.")
    }
}
System.print("Took %(((System.clock - start)*1000).round) milliseconds.")
