// version 1.1.2

fun main(args: Array<String>) {
    // create a regular 4 dimensional array and initialize successive elements to the values 1 to 120
    var m = 1
    val a4 = Array<Array<Array<Array<Int>>>>(5) {
        Array<Array<Array<Int>>>(4) {
            Array<Array<Int>>(3) {
                Array<Int>(2) { m++ }
            }
        }
    }

    println("First element = ${a4[0][0][0][0]}")  // access and print value of first element
    a4[0][0][0][0] = 121                          // change value of first element
    println()

    // access and print values of all elements
    val f = "%4d"
    for (i in 0..4)
        for (j in 0..3)
            for (k in 0..2)
                for (l in 0..1)
                    print(f.format(a4[i][j][k][l]))

}
