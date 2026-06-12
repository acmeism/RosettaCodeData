import "./math" for Int

var results = [2, 3, 5, 7] // number must begin with a prime digit
var odigits = [3, 7]       // other digits must be 3 or 7 as there would be a composite substring otherwise
var discarded = []
var tests = 4 // i.e. to obtain initial results in the first place

// check 2 digit numbers or greater
// note that 'results' is a moving feast. If the loop eventually terminates that's all there are.
for (r in results) {
    for (od in odigits) {
        // the last digit of r and od must be different otherwise number would be divisible by 11
        if ((r % 10) != od) {
            var n = r * 10 + od
            if (Int.isPrime(n)) results.add(n) else discarded.add(n)
            tests = tests + 1
        }
    }
}

System.print("There are %(results.count) primes where all substrings are also primes, namely:")
System.print(results)
System.print("\nThe following numbers were also tested for primality but found to be composite:")
System.print(discarded)
System.print("\nTotal number of primality tests = %(tests)")
