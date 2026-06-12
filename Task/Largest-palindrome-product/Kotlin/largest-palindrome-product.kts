fun reverseDigits(n: Long): Long {
    var num = n
    var result: Long = 0
    while (num > 0) {
        result = num % 10 + result * 10
        num /= 10
    }
    return result
}

fun main() {
    var power: Long = 10
    for (n in 2..10) {
        val low = power * 9
        power *= 10
        val high = power - 1
        var found = false
        var i = high
        while (i >= low && !found) {
            val j = reverseDigits(i)
            val possibleProduct = i * power + j
            // 'highCopy' cannot be even nor end in 5 to produce a product ending in 9
            var highCopy = high
            while (highCopy > low) {
                if (highCopy % 10 != 5L) {
                    val divisor = possibleProduct / highCopy
                    if (divisor > high) {
                        break
                    }
                    if (possibleProduct % highCopy == 0L) {
                        println("Largest palindromic product of two $n-digit integers: $highCopy x $divisor = $possibleProduct")
                        found = true
                        break
                    }
                }
                highCopy -= 2
            }
            i--
        }
    }
}

