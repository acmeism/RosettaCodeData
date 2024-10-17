fun printFactors(n: Int) {
    if (n < 1) return
    print("$n => ")
    (1..n / 2)
        .filter { n % it == 0 }
        .forEach { print("$it ") }
    println(n)
}

fun main(args: Array<String>) {
    val numbers = intArrayOf(11, 21, 32, 45, 67, 96)
    for (number in numbers) printFactors(number)
}
