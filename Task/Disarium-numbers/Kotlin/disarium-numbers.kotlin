fun power(n: Int, exp: Int): Int {
    return when {
        exp > 1 -> n * power(n, exp-1)
        exp == 1 -> n
        else -> 1
    }
}

fun is_disarium(num: Int): Boolean {
    val n = num.toString()
    var sum = 0
    for (i in 1..n.length) {
        sum += power (n[i-1] - '0', i)
    }
    return sum == num
}

fun main() {
    var i = 0
    var count = 0
    while (count < 19) {
        if (is_disarium(i)) {
            print("$i ")
            count++
        }
        i++
    }
    println("")
}
