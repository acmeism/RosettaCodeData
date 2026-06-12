import "./math" for Int
import "./fmt" for Fmt

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

var max = 1e6
var a = List.filled(max, 0)
var sumPhi = 0
for (n in 1..max) {
    sumPhi = sumPhi + totient.call(n)
    if (Int.isPrime(n)) {
        a[n-1] = a[n-2]
    } else {
        a[n-1] = n * (n - 1) / 2 + 1 - sumPhi
    }
}

System.print("Number of pairs with common factors - first one hundred terms:")
Fmt.tprint("$,5d ", a[0..99], 10)
System.print()
var limits = [1, 10, 1e2, 1e3, 1e4, 1e5, 1e6]
for (limit in limits) {
    Fmt.print("The $,r term: $,d", limit, a[limit-1])
}
