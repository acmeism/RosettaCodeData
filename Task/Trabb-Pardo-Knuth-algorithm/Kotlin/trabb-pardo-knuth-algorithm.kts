// version 1.1.2

fun f(x: Double) = Math.sqrt(Math.abs(x)) + 5.0 * x * x * x

fun main(args: Array<String>) {
    val da = DoubleArray(11)
    println("Please enter 11 numbers:")
    var i = 0
    while (i < 11) {
        print("  ${"%2d".format(i + 1)}: ")
        val d = readLine()!!.toDoubleOrNull()
        if (d == null)
            println("Not a valid number, try again")
        else
            da[i++] = d
    }
    println("\nThe sequence you just entered in reverse is:")
    da.reverse()
    println(da.contentToString())
    println("\nProcessing this sequence...")
    for (j in 0..10) {
        val v = f(da[j])
        print("  ${"%2d".format(j + 1)}: ")
        if (v > 400.0)
            println("Overflow!")
        else
            println(v)
    }
}
