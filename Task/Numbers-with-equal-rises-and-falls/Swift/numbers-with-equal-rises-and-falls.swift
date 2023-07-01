import Foundation

func equalRisesAndFalls(_ n: Int) -> Bool {
    var total = 0
    var previousDigit = -1
    var m = n
    while m > 0 {
        let digit = m % 10
        m /= 10
        if previousDigit > digit {
            total += 1
        } else if previousDigit >= 0 && previousDigit < digit {
            total -= 1
        }
        previousDigit = digit
    }
    return total == 0
}

var count = 0
var n = 0
let limit1 = 200
let limit2 = 10000000
print("The first \(limit1) numbers in the sequence are:")
while count < limit2 {
    n += 1
    if equalRisesAndFalls(n) {
        count += 1
        if count <= limit1 {
            print(String(format: "%3d", n), terminator: count % 20 == 0 ? "\n" : " ")
        }
    }
}
print("\nThe \(limit2)th number in the sequence is \(n).")
