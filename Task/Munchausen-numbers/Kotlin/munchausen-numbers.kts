// version 1.0.6

val powers = IntArray(10)

fun isMunchausen(n: Int): Boolean {
    if (n < 0) return false
    var sum = 0L
    var nn = n
    while (nn > 0) {
        sum += powers[nn % 10]
        if (sum > n.toLong()) return false
        nn /= 10
    }
    return sum == n.toLong()
}

fun main(args: Array<String>) {
   // cache n ^ n for n in 0..9, defining 0 ^ 0 = 0 for this purpose
   for (i in 1..9) powers[i] = Math.pow(i.toDouble(), i.toDouble()).toInt()

   // check numbers 0 to 500 million
   println("The Munchausen numbers between 0 and 500 million are:")
   for (i in 0..500000000) if (isMunchausen(i))print ("$i ")
   println()
}
