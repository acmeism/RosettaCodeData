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

System.print("The first four perfect numbers are:")
var count = 0
var i = 2
while (count < 4) {
    if (isPerfect.call(i)) {
        System.write("%(i) ")
        count = count + 1
    }
    i = i + 2  // there are no known odd perfect numbers
}
System.print()
