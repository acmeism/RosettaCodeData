func getDigits(_ num: Int) -> Array<Int> {
    var n = num
    var digits = Array(repeating: 0, count: 10)
    while true {
        digits[n % 10] += 1
        n /= 10
        if n == 0 {
            break
        }
    }
    return digits
}

// Returns true if n, 2n, ..., 6n all have the same base 10 digits.
func sameDigits(_ n: Int) -> Bool {
    let digits = getDigits(n)
    for i in 2...6 {
        if digits != getDigits(i * n) {
            return false
        }
    }
    return true
}

var p = 100
loop: while true {
    for n in stride(from: p + 2, through: (p * 10) / 6, by: 3) {
        if sameDigits(n) {
            print(" n = \(n)")
            for i in 2...6 {
                print("\(i)n = \(i * n)")
            }
            break loop
        }
    }
    p *= 10
}
