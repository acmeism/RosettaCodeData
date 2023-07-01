func isPrime(number: Int) -> Bool {
    if number < 2 {
        return false
    }
    if number % 2 == 0 {
        return number == 2
    }
    if number % 3 == 0 {
        return number == 3
    }
    if number % 5 == 0 {
        return number == 5
    }
    var p = 7
    let wheel = [4,2,4,2,4,6,2,6]
    while true {
        for w in wheel {
            if p * p > number {
                return true
            }
            if number % p == 0 {
                return false
            }
            p += w
        }
    }
}

func nextPrimeDigitNumber(number: Int) -> Int {
    if number == 0 {
        return 2
    }
    switch number % 10 {
    case 2:
        return number + 1
    case 3, 5:
        return number + 2
    default:
        return 2 + nextPrimeDigitNumber(number: number/10) * 10
    }
}

let limit = 1000000000
var n = 0
var max = 0
var count = 0
print("First 25 SPDS primes:")
while n < limit {
    n = nextPrimeDigitNumber(number: n)
    if !isPrime(number: n) {
        continue
    }
    if count < 25 {
        print(n, terminator: " ")
    } else if count == 25 {
        print()
    }
    count += 1
    if (count == 100) {
        print("Hundredth SPDS prime: \(n)")
    } else if (count == 1000) {
        print("Thousandth SPDS prime: \(n)")
    } else if (count == 10000) {
        print("Ten thousandth SPDS prime: \(n)")
    }
    max = n
}
print("Largest SPDS prime less than \(limit): \(max)")
