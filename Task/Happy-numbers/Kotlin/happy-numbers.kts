// version 1.0.5-2

fun isHappy(n: Int): Boolean {
    val cache = mutableListOf<Int>()
    var sum = 0
    var nn = n
    var digit: Int
    while (nn != 1) {
        if (nn in cache) return false
        cache.add(nn)
        while (nn != 0) {
            digit = nn % 10
            sum += digit * digit
            nn /= 10
        }
        nn = sum
        sum = 0
    }
    return true
}

fun main(args: Array<String>) {
    var num = 1
    val happyNums = mutableListOf<Int>()
    while (happyNums.size < 8) {
        if (isHappy(num)) happyNums.add(num)
        num++
    }
    println("First 8 happy numbers : " + happyNums.joinToString(", "))
}
