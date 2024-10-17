fun main() {
    print("Enter size of matrix : ")
    val n = readln().toInt()
    println()
    val identity = Array(n) { i ->
        IntArray(n) { j ->
            if (i == j) 1 else 0
        }
    }

    // print identity matrix if n <= 40
    if (n <= 40)
        for (row in identity) println(row.joinToString(" "))
    else
        println("Matrix is too big to display on 80 column console")
}
