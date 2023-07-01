import "./math" for Int

var powers = [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
System.print("Own digits power sums for N = 3 to 9 inclusive:")
for (n in 3..9) {
    for (d in 2..9) powers[d] = powers[d] * d
    var i = 10.pow(n-1)
    var max = i * 10
    var lastDigit = 0
    var sum = 0
    var digits = null
    while (i < max) {
        if (lastDigit == 0) {
            digits = Int.digits(i)
            sum = digits.reduce(0) { |acc, d|  acc + powers[d] }
        } else if (lastDigit == 1) {
            sum = sum + 1
        } else {
            sum = sum + powers[lastDigit] - powers[lastDigit-1]
        }
        if (sum == i) {
            System.print(i)
            if (lastDigit == 0) System.print(i + 1)
            i = i + 10 - lastDigit
            lastDigit = 0
        } else if (sum > i) {
            i = i + 10 - lastDigit
            lastDigit = 0
        } else if (lastDigit < 9) {
            i = i + 1
            lastDigit = lastDigit + 1
        } else {
            i = i + 1
            lastDigit = 0
        }
    }
}
