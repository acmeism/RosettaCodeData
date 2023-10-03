import "./math" for Int

var count = 0
var limit = 25 // or 62
var n = 49
var deceptive = []
while (count < limit) {
    if (!Int.isPrime(n) && n % 3 != 0 && n % 5 != 0 && Int.modPow(10, n-1, n) == 1) {
        deceptive.add(n)
        count = count + 1
    }
    n = n + 2
}
System.print("The first %(limit) deceptive numbers are:")
System.print(deceptive)
