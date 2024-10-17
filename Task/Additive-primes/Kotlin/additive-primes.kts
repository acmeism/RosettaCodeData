fun isPrime(n: Int): Boolean {
    if (n <= 3) return n > 1
    if (n % 2 == 0 || n % 3 == 0) return false
    var i = 5
    while (i * i <= n) {
        if (n % i == 0 || n % (i + 2) == 0) return false
        i += 6
    }
    return true
}

fun digitSum(n: Int): Int {
    var sum = 0
    var num = n
    while (num > 0) {
        sum += num % 10
        num /= 10
    }
    return sum
}

fun main() {
    var additivePrimes = 0
    for (i in 2 until 500) {
        if (isPrime(i) and isPrime(digitSum(i))) {
            additivePrimes++
            print("$i ")
        }
    }
    println("\nFound $additivePrimes additive primes less than 500")
}
