// version 1.1

fun sumProperDivisors(n: Int) =
    if (n < 2) 0 else (1..n / 2).filter { (n % it) == 0 }.sum()

fun main(args: Array<String>) {
    var sum: Int
    var deficient = 0
    var perfect = 0
    var abundant = 0

    for (n in 1..20000) {
        sum = sumProperDivisors(n)
        when {
            sum < n -> deficient++
            sum == n -> perfect++
            sum > n -> abundant++
        }
    }

    println("The classification of the numbers from 1 to 20,000 is as follows:\n")
    println("Deficient = $deficient")
    println("Perfect   = $perfect")
    println("Abundant  = $abundant")
}
