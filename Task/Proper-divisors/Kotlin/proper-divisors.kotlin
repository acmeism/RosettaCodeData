// version 1.0.5-2

fun listProperDivisors(limit: Int) {
    if (limit < 1) return
    for(i in 1..limit) {
        print(i.toString().padStart(2) + " -> ")
        if (i == 1) {
            println("(None)")
            continue
        }
        (1..i/2).filter{ i % it == 0 }.forEach { print(" $it") }
        println()
    }
}

fun countProperDivisors(n: Int): Int {
    if (n < 2) return 0
    return (1..n/2).count { (n % it) == 0 }
}

fun main(args: Array<String>) {
    println("The proper divisors of the following numbers are :\n")
    listProperDivisors(10)
    println()
    var count: Int
    var maxCount = 0
    val most: MutableList<Int> = mutableListOf(1)
    for (n in 2..20000) {
        count = countProperDivisors(n)
        if (count == maxCount)
            most.add(n)
        else if (count > maxCount) {
            maxCount = count
            most.clear()
            most.add(n)
        }
    }
    println("The following number(s) have the most proper divisors, namely " + maxCount + "\n")
    for (n in most) println(n)
}
