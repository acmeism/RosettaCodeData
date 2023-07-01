import "/fmt" for Fmt

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

System.print(" n  phi   prime")
System.print("---------------")
var count = 0
for (n in 1..25) {
    var tot = totient.call(n)
    var isPrime = (n - 1) == tot
    if (isPrime) count = count + 1
    System.print("%(Fmt.d(2, n))   %(Fmt.d(2, tot))   %(isPrime)")
}
System.print("\nNumber of primes up to 25     = %(count)")
for (n in 26..100000) {
    var tot = totient.call(n)
    if (tot == n - 1) count = count + 1
    if (n == 100 || n == 1000 || n%10000 == 0) {
        System.print("\nNumber of primes up to %(Fmt.d(-6, n)) = %(count)")
    }
}
