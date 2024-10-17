//  version 1.1.4

fun isPrime(n: Int) : Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun reverseNumber(n: Int) : Int {
    if (n < 10) return n
    var sum = 0
    var nn = n
    while (nn > 0) {
        sum = 10 * sum + nn % 10
        nn /= 10
    }
    return sum
}

fun isEmirp(n: Int) : Boolean {
    if (!isPrime(n)) return false
    val reversed = reverseNumber(n)
    return reversed != n && isPrime(reversed)
}

fun main(args: Array<String>) {
    println("The first 20 Emirp primes are :")
    var count = 0
    var i = 13
    do {
        if (isEmirp(i)) {
            print(i.toString() + " ")
            count++
        }
        i += 2
    }
    while (count < 20)
    println()
    println()
    println("The Emirp primes between 7700 and 8000 are :")
    i = 7701
    do {
        if (isEmirp(i)) print(i.toString() + " ")
        i += 2
    }
    while (i < 8000)
    println()
    println()
    print("The 10,000th Emirp prime is : ")
    i = 13
    count = 0
    do {
        if (isEmirp(i)) count++
        if (count == 10000) break
        i += 2
    }
    while(true)
    print(i)
}
