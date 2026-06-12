import "./math" for Int

var limit = 11 // as far as we can go without using BigInt
System.print("The first %(limit) prime Fibonacci numbers are:")
var count = 0
var f1 = 1
var f2 = 1
while (count < limit) {
    var f3 = f1 + f2
    if (Int.isPrime(f3)) {
        System.write("%(f3) ")
        count = count + 1
    }
    f1 = f2
    f2 = f3
}
System.print()
