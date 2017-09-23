// version 1.0.6

fun initMovingAverage(p: Int): (Double) -> Double {
    if (p < 1) throw IllegalArgumentException("Period must be a positive integer")
    val list = mutableListOf<Double>()
    return {
        list.add(it)
        if (list.size > p) list.removeAt(0)
        list.average()
    }
}

fun main(args: Array<String>) {
    val sma4 = initMovingAverage(4)
    val sma5 = initMovingAverage(5)
    val numbers = listOf(1.0, 2.0, 3.0, 4.0, 5.0, 5.0, 4.0, 3.0, 2.0, 1.0)
    println("num\tsma4\tsma5\n")
    for (number in numbers) println("${number}\t${sma4(number)}\t${sma5(number)}")
}
