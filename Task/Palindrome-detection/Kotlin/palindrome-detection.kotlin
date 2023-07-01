// version 1.1.2

/* These functions deal automatically with Unicode as all strings are UTF-16 encoded in Kotlin */

fun isExactPalindrome(s: String) = (s == s.reversed())

fun isInexactPalindrome(s: String): Boolean {
    var t = ""
    for (c in s) if (c.isLetterOrDigit()) t += c
    t = t.toLowerCase()
    return t == t.reversed()
}

fun main(args: Array<String>) {
    val candidates = arrayOf("rotor", "rosetta", "step on no pets", "été")
    for (candidate in candidates) {
        println("'$candidate' is ${if (isExactPalindrome(candidate)) "an" else "not an"} exact palindrome")
    }
    println()
    val candidates2 = arrayOf(
         "In girum imus nocte et consumimur igni",
         "Rise to vote, sir",
         "A man, a plan, a canal - Panama!",
         "Ce repère, Perec"  // note: 'è' considered a distinct character from 'e'
    )
    for (candidate in candidates2) {
        println("'$candidate' is ${if (isInexactPalindrome(candidate)) "an" else "not an"} inexact palindrome")
    }
}
