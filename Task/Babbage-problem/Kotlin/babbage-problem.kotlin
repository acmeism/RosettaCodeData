fun main(args: Array<String>) {
    var number = 520L
    var square = 520 * 520L

    while (true) {
        val last6 = square.toString().takeLast(6)
        if (last6 == "269696") {
            println("The smallest number is $number whose square is $square")
            return
        }
        number += 2
        square = number * number
    }
}
