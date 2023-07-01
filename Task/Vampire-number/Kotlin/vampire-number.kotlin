// version 1.1

data class Fangs(val fang1: Long = 0L, val fang2: Long = 0L)

fun pow10(n: Int): Long = when {
    n < 0 -> throw IllegalArgumentException("Can't be negative")
    else -> {
        var pow = 1L
        for (i in 1..n) pow *= 10L
        pow
    }
}

fun countDigits(n: Long): Int = when {
    n < 0L -> throw IllegalArgumentException("Can't be negative")
    n == 0L -> 1
    else -> {
        var count = 0
        var nn = n
        while (nn > 0L) {
            count++
            nn /= 10L
        }
        count
    }
}

fun hasTrailingZero(n: Long): Boolean = when {
    n < 0L -> throw IllegalArgumentException("Can't be negative")
    else -> n % 10L == 0L
}

fun sortedString(s: String): String {
    val ca = s.toCharArray()
    ca.sort()
    return String(ca)
}

fun isVampiric(n: Long, fl: MutableList<Fangs>): Boolean {
    if (n < 0L) return false
    val len = countDigits(n)
    if (len % 2L == 1L) return false
    val hlen = len / 2
    val first = pow10(hlen - 1)
    val last = 10L * first
    var j: Long
    var cd: Int
    val ss = sortedString(n.toString())
    for (i in first until last) {
        if (n % i != 0L) continue
        j = n / i
        if (j < i) return fl.size > 0
        cd = countDigits(j)
        if (cd > hlen) continue
        if (cd < hlen) return fl.size > 0
        if (ss != sortedString(i.toString() + j.toString())) continue
        if (!(hasTrailingZero(i) && hasTrailingZero(j))) {
            fl.add(Fangs(i, j))
        }
    }
    return fl.size > 0
}

fun showFangs(fangsList: MutableList<Fangs>): String {
    var s = ""
    for ((fang1, fang2) in fangsList) {
        s += " = $fang1 x $fang2"
    }
    return s
}

fun main(args: Array<String>) {
    println("The first 25 vampire numbers and their fangs are:")
    var count = 0
    var n: Long = 0
    val fl = mutableListOf<Fangs>()
    while (true) {
        if (isVampiric(n, fl)) {
            count++
            println("${"%2d".format(count)} : $n\t${showFangs(fl)}")
            fl.clear()
            if (count == 25) break
        }
        n++
    }
    println()
    val va = longArrayOf(16758243290880L, 24959017348650L, 14593825548650L)
    for (v in va) {
        if (isVampiric(v, fl)) {
            println("$v\t${showFangs(fl)}")
            fl.clear()
        } else {
            println("$v\t = not vampiric")
        }
    }
}
