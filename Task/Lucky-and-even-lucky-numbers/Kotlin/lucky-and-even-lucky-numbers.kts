// version 1.1.51

typealias IAE = IllegalArgumentException

val luckyOdd  = MutableList(100000) { it * 2 + 1 }
val luckyEven = MutableList(100000) { it * 2 + 2 }

fun filterLuckyOdd() {
    var n = 2
    while (n < luckyOdd.size) {
        val m = luckyOdd[n - 1]
        val end = (luckyOdd.size / m) * m - 1
        for (j in end downTo m - 1 step m) luckyOdd.removeAt(j)
        n++
    }
}

fun filterLuckyEven() {
    var n = 2
    while (n < luckyEven.size) {
        val m = luckyEven[n - 1]
        val end = (luckyEven.size / m) * m - 1
        for (j in end downTo m - 1 step m) luckyEven.removeAt(j)
        n++
    }
}

fun printSingle(j: Int, odd: Boolean) {
    if (odd) {
        if (j >= luckyOdd.size) throw IAE("Argument is too big")
        println("Lucky number $j = ${luckyOdd[j - 1]}")
    }
    else {
        if (j >= luckyEven.size) throw IAE("Argument is too big")
        println("Lucky even number $j = ${luckyEven[j - 1]}")
    }
}

fun printRange(j: Int, k: Int, odd: Boolean) {
    if (odd) {
        if (k >= luckyOdd.size) throw IAE("Argument is too big")
        println("Lucky numbers $j to $k are:\n${luckyOdd.drop(j - 1).take(k - j + 1)}")
    }
    else {
        if (k >= luckyEven.size) throw IAE("Argument is too big")
        println("Lucky even numbers $j to $k are:\n${luckyEven.drop(j - 1).take(k - j + 1)}")
    }
}

fun printBetween(j: Int, k: Int, odd: Boolean) {
    val range = mutableListOf<Int>()
    if (odd) {
        val max = luckyOdd[luckyOdd.lastIndex]
        if (j > max || k > max) {
            throw IAE("At least one argument is too big")
        }
        for (num in luckyOdd) {
            if (num < j) continue
            if (num > k) break
            range.add(num)
        }
        println("Lucky numbers between $j and $k are:\n$range")
    }
    else {
        val max = luckyEven[luckyEven.lastIndex]
        if (j > max || k > max) {
            throw IAE("At least one argument is too big")
        }
        for (num in luckyEven) {
            if (num < j) continue
            if (num > k) break
            range.add(num)
        }
        println("Lucky even numbers between $j and $k are:\n$range")
    }
}

fun main(args: Array<String>) {
    if (args.size !in 1..3) throw IAE("There must be between 1 and 3 command line arguments")
    filterLuckyOdd()
    filterLuckyEven()
    val j = args[0].toIntOrNull()
    if (j == null || j < 1) throw IAE("First argument must be a positive integer")
    if (args.size == 1) { printSingle(j, true); return }

    if (args.size == 2) {
        val k = args[1].toIntOrNull()
        if (k == null) throw IAE("Second argument must be an integer")
        if (k >= 0) {
            if (j > k) throw IAE("Second argument can't be less than first")
            printRange(j, k, true)
        }
        else {
           val l = -k
            if (j > l) throw IAE("The second argument can't be less in absolute value than first")
            printBetween(j, l, true)
        }
        return
    }

    var odd =
        if (args[2].toLowerCase() == "lucky") true
        else if (args[2].toLowerCase() == "evenlucky") false
        else throw IAE("Third argument is invalid")

    if (args[1] == ",") {
        printSingle(j, odd)
        return
    }

    val k = args[1].toIntOrNull()
    if (k == null) throw IAE("Second argument must be an integer or a comma")

    if (k >= 0) {
        if (j > k) throw IAE("Second argument can't be less than first")
        printRange(j, k, odd)
    }
    else {
        val l = -k
        if (j > l) throw IAE("The second argument can't be less in absolute value than first")
        printBetween(j, l, odd)
    }
}
