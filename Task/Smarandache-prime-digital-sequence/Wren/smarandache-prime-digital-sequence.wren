import "./math" for Int

var limit = 1000
var spds = List.filled(limit, 0)
spds[0] = 2
var i = 3
var count = 1
while (count < limit) {
    if (Int.isPrime(i)) {
        var digits = i.toString
        if (digits.all { |d| "2357".contains(d) }) {
            spds[count] = i
            count = count + 1
        }
    }
    i = i + 2
    if (i > 10) {
        var j = i % 10
        if (j == 1 || j == 5) {
            i = i + 2
        } else if (j == 9) {
            i = i + 4
        }
    }
}
System.print("The first 25 SPDS primes are:")
System.print(spds.take(25).toList)
System.print("\nThe 100th SPDS prime is %(spds[99])")
System.print("\nThe 1,000th SPDS prime is %(spds[999])")
