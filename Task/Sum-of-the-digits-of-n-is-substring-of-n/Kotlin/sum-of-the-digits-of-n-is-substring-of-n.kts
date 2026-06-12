fun digitSum(n: Int): Int {
    var nn = n
    var sum = 0
    while (nn > 0) {
        sum += (nn % 10)
        nn /= 10
    }
    return sum
}

fun main() {
    var c = 0
    for (i in 0 until 1000) {
        val ds = digitSum(i)
        if (i.toString().contains(ds.toString())) {
            print("%3d ".format(i))

            c += 1
            if (c == 8) {
                println()
                c = 0
            }
        }
    }
    println()
}
