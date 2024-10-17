// version 1.1

fun sumDigits(n: Int): Int = when {
        n <= 0 -> 0
        else   -> {
            var sum = 0
            var nn = n
            while (nn > 0) {
                sum += nn % 10
                nn /= 10
            }
            sum
        }
    }

fun isHarshad(n: Int): Boolean = (n % sumDigits(n) == 0)

fun main(args: Array<String>) {
    println("The first 20 Harshad numbers are:")
    var count = 0
    var i = 0

    while (true) {
        if (isHarshad(++i)) {
            print("$i ")
            if (++count == 20) break
        }
    }

    println("\n\nThe first Harshad number above 1000 is:")
    i = 1000

    while (true) {
        if (isHarshad(++i)) {
            println(i)
            return
        }
    }
}
