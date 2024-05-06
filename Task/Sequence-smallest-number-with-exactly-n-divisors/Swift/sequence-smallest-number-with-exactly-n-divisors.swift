// See https://en.wikipedia.org/wiki/Divisor_function
func divisorCount(number: Int) -> Int {
    var n = number
    var total = 1
    // Deal with powers of 2 first
    while n % 2 == 0 {
        total += 1
        n /= 2
    }
    // Odd prime factors up to the square root
    var p = 3
    while p * p <= n {
        var count = 1
        while n % p == 0 {
            count += 1
            n /= p
        }
        total *= count
        p += 2
    }
    // If n > 1 then it's prime
    if n > 1 {
        total *= 2
    }
    return total
}

let limit = 15
var sequence = Array(repeating: 0, count: limit)
var count = 0
var n = 1
while count < limit {
    let divisors = divisorCount(number: n)
    if divisors <= limit && sequence[divisors - 1] == 0 {
        sequence[divisors - 1] = n
        count += 1
    }
    n += 1
}
for n in sequence {
    print(n, terminator: " ")
}
print()
