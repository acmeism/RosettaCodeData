// version 1.0.6

fun reverseGender(s: String): String {
    var t = s
    val words = listOf("She", "she", "Her",  "her",  "hers", "He",   "he",   "His",  "his",  "him")
    val repls = listOf("He_", "he_", "His_", "his_" ,"his_", "She_", "she_", "Her_", "her_", "her_")
    for (i in 0 until words.size) {
        val r = Regex("""\b${words[i]}\b""")
        t = t.replace(r, repls[i])
    }
    return t.replace("_", "")
}

fun main(args: Array<String>) {
    println(reverseGender("She was a soul stripper. She took his heart!"))
    println(reverseGender("He was a soul stripper. He took her heart!"))
    println(reverseGender("She wants what's hers, he wants her and she wants him!"))
    println(reverseGender("Her dog belongs to him but his dog is hers!"))
}
