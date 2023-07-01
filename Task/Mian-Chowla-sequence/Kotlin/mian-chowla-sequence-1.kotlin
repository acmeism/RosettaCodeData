// Version 1.3.21

fun mianChowla(n: Int): List<Int> {
    val mc = MutableList(n) { 0 }
    mc[0] = 1
    val hs = HashSet<Int>(n * (n + 1) / 2)
    hs.add(2)
    val hsx = mutableListOf<Int>()
    for (i in 1 until n) {
        hsx.clear()
        var j = mc[i - 1]
        outer@ while (true) {
            j++
            mc[i] = j
            for (k in 0..i) {
                val sum = mc[k] + j
                if (hs.contains(sum)) {
                    hsx.clear()
                    continue@outer
                }
                hsx.add(sum)
            }
            hs.addAll(hsx)
            break
        }
    }
    return mc
}

fun main() {
    val mc = mianChowla(100)
    println("The first 30 terms of the Mian-Chowla sequence are:")
    println(mc.subList(0, 30))
    println("\nTerms 91 to 100 of the Mian-Chowla sequence are:")
    println(mc.subList(90, 100))
}
