fun reverseEachWord(s: String) = s.split(" ").joinToString(" ")  { it.reversed() }
fun reverseWordOrder(s: String) = s.split(" ").reversed().joinToString(" ")

fun main(args: Array<String>) {
    val original = "rosetta code phrase reversal"
    val reversed = original.reversed()
    println("Original string => $original")
    println("Reversed string => $reversed")
    println("Reversed words  => ${reverseEachWord(original)}")
    // Either:
    println("Reversed order  => ${reverseWordOrder(original)}")
    // Or:
    println("Reversed order  => ${reverseEachWord(reversed)}")
}
