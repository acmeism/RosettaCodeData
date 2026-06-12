import Foundation

let wheel = [4,2,4,2,4,6,2,6]

func isPrime(_ number: Int) -> Bool {
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

func nextPrimeDigitNumber(_ number: Int) -> Int {
    if number == 0 {
        return 2
    }
    switch number % 10 {
    case 2:
        return number + 1
    case 3, 5:
        return number + 2
    default:
        return 2 + nextPrimeDigitNumber(number/10) * 10
    }
}

func digitSum(_ num: Int) -> Int {
    var sum = 0
    var n = num
    while n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

func pad(string: String, width: Int) -> String {
    if string.count >= width {
        return string
    }
    return String(repeating: " ", count: width - string.count) + string
}

func commatize(_ number: Int) -> String {
    let n = NSNumber(value: number)
    return NumberFormatter.localizedString(from: n, number: .decimal)
}

let limit1 = 10000
let limit2 = 1000000000
let last = 10
var p = nextPrimeDigitNumber(0)
var n = 0

print("Extra primes less than \(commatize(limit1)):")
while p < limit1 {
    if isPrime(digitSum(p)) && isPrime(p) {
        n += 1
        print(pad(string: commatize(p), width: 5),
              terminator: n % 10 == 0 ? "\n" : " ")
    }
    p = nextPrimeDigitNumber(p)
}

print("\n\nLast \(last) extra primes less than \(commatize(limit2)):")

var extraPrimes = Array(repeating: 0, count: last)
while p < limit2 {
    if isPrime(digitSum(p)) && isPrime(p) {
        n += 1
        extraPrimes[n % last] = p
    }
    p = nextPrimeDigitNumber(p)
}

for i in stride(from: last - 1, through: 0, by: -1) {
    print("\(commatize(n - i)): \(commatize(extraPrimes[(n - i) % last]))")
}
