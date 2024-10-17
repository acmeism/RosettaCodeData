fun divisors(n: Int): List<Int> {
    val divs = mutableListOf(1)
    val divs2 = mutableListOf<Int>()

    var i = 2
    while (i * i <= n) {
        if (n % i == 0) {
            val j = n / i
            divs.add(i)
            if (i != j) {
                divs2.add(j)
            }
        }
        i++
    }

    divs.addAll(divs2.reversed())

    return divs
}

fun abundantOdd(searchFrom: Int, countFrom: Int, countTo: Int, printOne: Boolean): Int {
    var count = countFrom
    var n = searchFrom

    while (count < countTo) {
        val divs = divisors(n)
        val tot = divs.sum()
        if (tot > n) {
            count++
            if (!printOne || count >= countTo) {
                val s = divs.joinToString(" + ")
                if (printOne) {
                    println("$n < $s = $tot")
                } else {
                    println("%2d. %5d < %s = %d".format(count, n, s, tot))
                }
            }
        }

        n += 2
    }

    return n
}


fun main() {
    val max = 25
    println("The first $max abundant odd numbers are:")
    val n = abundantOdd(1, 0, 25, false)

    println("\nThe one thousandth abundant odd number is:")
    abundantOdd(n, 25, 1000, true)

    println("\nThe first abundant odd number above one billion is:")
    abundantOdd((1e9 + 1).toInt(), 0, 1, true)
}
