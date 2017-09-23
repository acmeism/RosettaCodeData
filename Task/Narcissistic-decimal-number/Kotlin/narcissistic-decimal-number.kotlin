// version 1.1.0

fun isNarcissistic(n: Int): Boolean {
    if (n < 0) throw IllegalArgumentException("Argument must be non-negative")
    var nn = n
    val digits = mutableListOf<Int>()
    val powers = IntArray(10) { 1 }
    while (nn > 0) {
       digits.add(nn % 10)
       for (i in 1..9) powers[i] *= i // no need to calculate powers[0]
       nn /= 10
    }
    val sum = digits.filter { it > 0 }.map { powers[it] }.sum()
    return n == sum
}

fun main(args: Array<String>) {
    println("The first 25 narcissistic (or Armstrong) numbers are:")
    var i = 0
    var count = 0
    do {
        if (isNarcissistic(i)) {
            print("$i ")
            count++
        }
        i++
    }
    while (count < 25)
}
