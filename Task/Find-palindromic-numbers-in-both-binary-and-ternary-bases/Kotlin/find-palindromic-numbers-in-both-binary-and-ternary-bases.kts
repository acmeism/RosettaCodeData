// version 1.0.5-2

/** converts decimal 'n' to its ternary equivalent */
fun Long.toTernaryString(): String = when {
    this < 0L  -> throw IllegalArgumentException("negative numbers not allowed")
    this == 0L -> "0"
    else   -> {
        var result = ""
        var n = this
        while (n > 0) {
            result += n % 3
            n /= 3
        }
        result.reversed()
    }
}

/** wraps java.lang.Long.toBinaryString in a Kotlin extension function */
fun Long.toBinaryString(): String = java.lang.Long.toBinaryString(this)

/** check if a binary or ternary numeric string 's' is palindromic */
fun isPalindromic(s: String): Boolean = (s == s.reversed())

/** print a number which is both a binary and ternary palindrome in all three bases */
fun printPalindrome(n: Long) {
    println("Decimal : $n")
    println("Binary  : ${n.toBinaryString()}")
    println("Ternary : ${n.toTernaryString()}")
    println()
}

/** create a ternary palindrome whose left part is the ternary equivalent of 'n' and return its decimal equivalent */
fun createPalindrome3(n: Long): Long {
    val ternary = n.toTernaryString()
    var power3 = 1L
    var sum = 0L
    val length = ternary.length
    for (i in 0 until length) {  // right part of palindrome is mirror image of left part
        if (ternary[i] > '0') sum += (ternary[i].toInt() - 48) * power3
        power3 *= 3L
    }
    sum += power3 // middle digit must be 1
    power3 *= 3L
    sum += n * power3  // value of left part is simply 'n' multiplied by appropriate power of 3
    return sum
}

fun main(args: Array<String>) {
    var i = 1L
    var p3: Long
    var count = 2
    var binStr: String
    println("The first 6 numbers which are palindromic in both binary and ternary are:\n")
    // we can assume the first two palindromic numbers as per the task description
    printPalindrome(0L)  // 0 is a palindrome in all 3 bases
    printPalindrome(1L)  // 1 is a palindrome in all 3 bases

    do {
        p3 = createPalindrome3(i)
        if (p3 % 2 > 0L)  { // cannot be even as binary equivalent would end in zero
            binStr = p3.toBinaryString()
            if (binStr.length % 2 == 1) { // binary palindrome must have an odd number of digits
                if (isPalindromic(binStr)) {
                    printPalindrome(p3)
                    count++
                }
            }
        }
        i++
    }
    while (count < 6)
}
