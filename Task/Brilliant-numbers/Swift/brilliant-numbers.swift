// Refs:
// https://www.geeksforgeeks.org/sieve-of-eratosthenes/?ref=leftbar-rightbar
// https://developer.apple.com/documentation/swift/array/init(repeating:count:)-5zvh4
// https://www.geeksforgeeks.org/brilliant-numbers/#:~:text=Brilliant%20Number%20is%20a%20number,25%2C%2035%2C%2049%E2%80%A6.

// Using Sieve of Eratosthenes
func primeArray(n: Int) -> [Bool] {

    var primeArr = [Bool](repeating: true, count: n + 1)
    primeArr[0] = false // setting zero to be not prime
    primeArr[1] = false // setting one to be not prime

    // finding all primes which are divisible by p and are greater than or equal to the square of it
    var p = 2
    while (p * p) <= n {
        if primeArr[p] == true {
            for j in stride(from: p * 2, through: n, by: p) {
                primeArr[j] = false
            }
        }
        p += 1
    }

    return primeArr
}


func digitsCount(n: Int) -> Int {
    // count number of digits for a number
    // increase the count if n divide by 10 is not equal to zero
    var num = n
    var count = 0;
    while num != 0 {
        num = num/10
        count += 1
    }

    return count
}


func isBrilliant(n: Int) -> Bool {
    // Set the prime array
    var isPrime = [Bool]()
    isPrime = primeArray(n: n)

    // Check if the number is the product of two prime numbers
    // Also check if the digit counts of those prime numbers are the same.
    for i in stride(from: 2, through: n, by: 1) { // i=2, n=50
        let x = n / i // i=2, n=50, x=25
        if (isPrime[i] && isPrime[x] && x * i == n) { // i=2, x=50, false
            if (digitsCount(n: i) == digitsCount(n: x)) {
                return true
            }
        }
    }

    return false
}


func print100Brilliants() {
    // Print the first 100 brilliant numbers
    var brilNums = [Int]()
    var count = 4
    while brilNums.count != 100 {
        if isBrilliant(n: count) {
            brilNums.append(count)
        }
        count += 1
    }

    print("First 100 brilliant numbers:\n", brilNums)
}


func printBrilliantsOfMagnitude() {
    // Print the brilliant numbers of base 10 up to magnitude of 6
    // Including their positions in the array.
    var basePower = 10.0
    var brilNums: [Double] = [0.0]
    var count = 1.0
    while basePower != pow(basePower, 6) {
        if isBrilliant(n: Int(count)) {
            brilNums.append(count)
            if count >= basePower {
                print("First brilliant number >= \(Int(basePower)): \(Int(count)) at position \(brilNums.firstIndex(of: count)!)")
                basePower *= 10
            }
        }
        count += 1
    }
}


print100Brilliants()
printBrilliantsOfMagnitude()
