import Foundation

func reverse(_ number: Int) -> Int {
    var rev = 0
    var n = number
    while n > 0 {
        rev = rev * 10 + n % 10
        n /= 10
    }
    return rev
}

func special(_ number: Int) -> Bool {
    var n = 2
    let rev = reverse(number)
    while n * n <= number {
        if number % n == 0 {
            if rev % reverse(n) != 0 {
                return false
            }
            let m = number / n
            if m != n && rev % reverse(m) != 0 {
                return false
            }
        }
        n += 1
    }
    return true
}

var count = 0
for n in 1..<200 {
    if special(n) {
        count += 1
        print(String(format: "%3d", n),
              terminator: count % 10 == 0 ? "\n" : " ")
    }
}
print("\n\(count) numbers found.")
