// version 1.1.4

data class DivMod(val quotient: Int, val remainder: Int)

fun egyptianDivide(dividend: Int, divisor: Int): DivMod {
    require (dividend >= 0 && divisor > 0)
    if (dividend < divisor) return DivMod(0, dividend)
    val powersOfTwo = mutableListOf(1)
    val doublings = mutableListOf(divisor)
    var doubling = divisor
    while (true) {
       doubling *= 2
       if (doubling > dividend) break
       powersOfTwo.add(powersOfTwo[powersOfTwo.lastIndex] * 2)
       doublings.add(doubling)
    }
    var answer = 0
    var accumulator = 0
    for (i in doublings.size - 1 downTo 0) {
        if (accumulator + doublings[i] <= dividend) {
            accumulator += doublings[i]
            answer += powersOfTwo[i]
            if (accumulator == dividend) break
        }
    }
    return DivMod(answer, dividend - accumulator)
}

fun main(args: Array<String>) {
    val dividend = 580
    val divisor = 34
    val (quotient, remainder) = egyptianDivide(dividend, divisor)
    println("$dividend divided by $divisor is $quotient with remainder $remainder")
}
