fun pas(rows: Int) {
    for (i in 0..rows - 1) {
        for (j in 0..i)
            print(ncr(i, j).toString() + " ")
        println()
    }
}

fun ncr(n: Int, r: Int) = fact(n) / (fact(r) * fact(n - r))

fun fact(n: Int) : Long {
    var ans = 1.toLong()
    for (i in 2..n)
        ans *= i
    return ans
}

fun main(args: Array<String>) = pas(args[0].toInt())
