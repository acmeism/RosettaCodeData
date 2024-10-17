// version 1.0.5-2

fun quadraticMean(vector: Array<Double>) : Double {
    val sum = vector.sumByDouble { it * it }
    return Math.sqrt(sum / vector.size)
}

fun main(args: Array<String>) {
    val vector = Array(10, { (it + 1).toDouble() })
    print("Quadratic mean of numbers 1 to 10 is ${quadraticMean(vector)}")
}
