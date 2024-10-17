// Version 1.2.60

fun main(args: Array<String>) {
    val a = mutableListOf(0)
    val used = mutableSetOf(0)
    val used1000 = mutableSetOf(0)
    var foundDup = false
    var n = 1
    while (n <= 15 || !foundDup || used1000.size < 1001) {
        var next = a[n - 1] - n
        if (next < 1 || used.contains(next)) next += 2 * n
        val alreadyUsed = used.contains(next)
        a.add(next)
        if (!alreadyUsed) {
            used.add(next)
            if (next in 0..1000) used1000.add(next)
        }
        if (n == 14) {
            println("The first 15 terms of the Recaman's sequence are: $a")
        }
        if (!foundDup && alreadyUsed) {
            println("The first duplicated term is a[$n] = $next")
            foundDup = true
        }
        if (used1000.size == 1001) {
            println("Terms up to a[$n] are needed to generate 0 to 1000")
        }
        n++
    }
}
