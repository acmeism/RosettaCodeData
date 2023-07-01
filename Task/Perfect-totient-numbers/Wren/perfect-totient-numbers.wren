var totient = Fn.new { |n|
    var tot = n
    var i = 2
    while (i*i <= n) {
        if (n%i == 0) {
            while(n%i == 0) n = (n/i).floor
            tot = tot - (tot/i).floor
        }
        if (i == 2) i = 1
        i = i + 2
    }
    if (n > 1) tot = tot - (tot/n).floor
    return tot
}

var perfect = []
var n = 1
while (perfect.count < 20) {
    var tot = n
    var sum = 0
    while (tot != 1) {
        tot = totient.call(tot)
        sum = sum + tot
    }
    if (sum == n) perfect.add(n)
    n = n + 2
}
System.print("The first 20 perfect totient numbers are:")
System.print(perfect)
