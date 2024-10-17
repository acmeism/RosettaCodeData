// version 1.1

fun farey(n: Int): List<String> {
    var a = 0
    var b = 1
    var c = 1
    var d = n
    val f = mutableListOf("$a/$b")
    while (c <= n) {
        val k = (n + b) / d
        val aa = a
        val bb = b
        a = c
        b = d
        c = k * c - aa
        d = k * d - bb
        f.add("$a/$b")
    }
    return f.toList()
}

fun main(args: Array<String>) {
    for (i in 1..11)
        println("${"%2d".format(i)}: ${farey(i).joinToString(" ")}")
    println()
    for (i in 100..1000 step 100)
        println("${"%4d".format(i)}: ${"%6d".format(farey(i).size)} fractions")
}
