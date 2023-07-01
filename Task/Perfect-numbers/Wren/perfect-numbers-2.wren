import "/math" for Int

var isPerfect = Fn.new { |n|
    if (n <= 2) return false
    var tot = 1
    for (i in 2..n.sqrt.floor) {
        if (n%i == 0) {
            tot = tot + i
            var q = (n/i).floor
            if (q > i) tot = tot + q
        }
    }
    return n == tot
}

System.print("The first seven perfect numbers are:")
var count = 0
var p = 2
while (count < 7) {
    var n = 2.pow(p) - 1
    if (Int.isPrime(n)) {
        n = n * 2.pow(p-1)
        if (isPerfect.call(n)) {
            System.write("%(n) ")
            count = count + 1
        }
    }
    p = p + 1
}
System.print()
