import "./math" for Int
import "./fmt" for Fmt

var digits = [2, 3, 5, 7] // the only digits which are primes
var digits2 = [3, 7]      // a prime > 5 can't end in 2 or 5
var candidates = [[2, 2], [3, 3], [5, 5], [7, 7]]  // [number, sum of its digits]

for (a in digits) {
    for (b in digits2) candidates.add([10*a + b, a + b])
}

for (a in digits) {
    for (b in digits) {
       for (c in digits2) candidates.add([100*a + 10*b + c, a + b + c])
    }
}

for (a in digits) {
    for (b in digits) {
        for (c in digits) {
            for (d in digits2) candidates.add([1000*a + 100*b + 10*c + d, a + b + c + d])
        }
    }
}

System.print("The extra primes under 10,000 are:")
var count = 0
for (cand in candidates) {
   if (Int.isPrime(cand[0]) && Int.isPrime(cand[1])) {
      count = count + 1
      Fmt.print("$2d: $4d", count, cand[0])
   }
}
