// version 1.0.5-2

@Suppress("DIVISION_BY_ZERO", "FLOAT_LITERAL_CONFORMS_ZERO")

fun main(args: Array<String>) {
    val inf     =  1.0 / 0.0
    val negInf  = -1.0 / 0.0
    val nan     =  0.0 / 0.0
    val negZero = -1.0e-325

    println("*** Indirect ***\n")
    println("Infinity          :  $inf")
    println("Negative infinity :  $negInf")
    println("Not a number      :  $nan")
    println("Negative zero     :  $negZero")

    println("\n*** Direct ***\n")
    println("Infinity          :  ${Double.POSITIVE_INFINITY}")
    println("Negative infinity :  ${Double.NEGATIVE_INFINITY}")
    println("Not a number      :  ${Double.NaN}")
    println("Negative zero     :  ${-0.0}")

    println("\n*** Calculations ***\n")
    println("inf * inf         :  ${inf * inf}")
    println("inf + negInf      :  ${inf + negInf}")
    println("nan / nan         :  ${nan / nan}")
    println("negZero + 0.0     :  ${negZero + 0.0}")
}
