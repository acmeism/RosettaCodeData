// version 1.2.31

fun printVerse(name: String) {
    val x = name.toLowerCase().capitalize()
    val y = if (x[0] in "AEIOU") x.toLowerCase() else x.substring(1)
    var b = "b$y"
    var f = "f$y"
    var m = "m$y"
    when (x[0]) {
        'B'  -> b = "$y"
        'F'  -> f = "$y"
        'M'  -> m = "$y"
        else -> {} // no adjustment needed
    }
    println("$x, $x, bo-$b")
    println("Banana-fana fo-$f")
    println("Fee-fi-mo-$m")
    println("$x!\n")
}

fun main(args: Array<String>) {
    listOf("Gary", "Earl", "Billy", "Felix", "Mary", "Steve").forEach { printVerse(it) }
}
