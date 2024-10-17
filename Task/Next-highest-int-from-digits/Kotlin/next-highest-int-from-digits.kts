import java.math.BigInteger
import java.text.NumberFormat

fun main() {
    for (s in arrayOf(
        "0",
        "9",
        "12",
        "21",
        "12453",
        "738440",
        "45072010",
        "95322020",
        "9589776899767587796600",
        "3345333"
    )) {
        println("${format(s)} -> ${format(next(s))}")
    }
    testAll("12345")
    testAll("11122")
}

private val FORMAT = NumberFormat.getNumberInstance()
private fun format(s: String): String {
    return FORMAT.format(BigInteger(s))
}

private fun testAll(str: String) {
    var s = str
    println("Test all permutations of:  $s")
    val sOrig = s
    var sPrev = s
    var count = 1

    //  Check permutation order.  Each is greater than the last
    var orderOk = true
    val uniqueMap: MutableMap<String, Int> = HashMap()
    uniqueMap[s] = 1
    while (next(s).also { s = it }.compareTo("0") != 0) {
        count++
        if (s.toLong() < sPrev.toLong()) {
            orderOk = false
        }
        uniqueMap.merge(s, 1) { a: Int?, b: Int? -> Integer.sum(a!!, b!!) }
        sPrev = s
    }
    println("    Order:  OK =  $orderOk")

    //  Test last permutation
    val reverse = StringBuilder(sOrig).reverse().toString()
    println("    Last permutation:  Actual = $sPrev, Expected = $reverse, OK = ${sPrev.compareTo(reverse) == 0}")

    //  Check permutations unique
    var unique = true
    for (key in uniqueMap.keys) {
        if (uniqueMap[key]!! > 1) {
            unique = false
        }
    }
    println("    Permutations unique:  OK =  $unique")

    //  Check expected count.
    val charMap: MutableMap<Char, Int> = HashMap()
    for (c in sOrig.toCharArray()) {
        charMap.merge(c, 1) { a: Int?, b: Int? -> Integer.sum(a!!, b!!) }
    }
    var permCount = factorial(sOrig.length.toLong())
    for (c in charMap.keys) {
        permCount /= factorial(charMap[c]!!.toLong())
    }
    println("    Permutation count:  Actual = $count, Expected = $permCount, OK = ${count.toLong() == permCount}")
}

private fun factorial(n: Long): Long {
    var fact: Long = 1
    for (num in 2..n) {
        fact *= num
    }
    return fact
}

private fun next(s: String): String {
    val sb = StringBuilder()
    var index = s.length - 1
    //  Scan right-to-left through the digits of the number until you find a digit with a larger digit somewhere to the right of it.
    while (index > 0 && s[index - 1] >= s[index]) {
        index--
    }
    //  Reached beginning.  No next number.
    if (index == 0) {
        return "0"
    }

    //  Find digit on the right that is both more than it, and closest to it.
    var index2 = index
    for (i in index + 1 until s.length) {
        if (s[i] < s[index2] && s[i] > s[index - 1]) {
            index2 = i
        }
    }

    //  Found data, now build string
    //  Beginning of String
    if (index > 1) {
        sb.append(s.subSequence(0, index - 1))
    }

    //  Append found, place next
    sb.append(s[index2])

    //  Get remaining characters
    val chars: MutableList<Char> = ArrayList()
    chars.add(s[index - 1])
    for (i in index until s.length) {
        if (i != index2) {
            chars.add(s[i])
        }
    }

    //  Order the digits to the right of this position, after the swap; lowest-to-highest, left-to-right.
    chars.sort()
    for (c in chars) {
        sb.append(c)
    }
    return sb.toString()
}
