val p = arrayOf(
    false, false, true, true, false,
    true, false, true, false, false,
    false, true, false, true, false,
    false, false, true, false
)

fun isStrange(n: Long): Boolean {
    if (n < 10) {
        return false
    }

    var nn = n
    while (nn >= 10) {
        if (!p[(nn % 10 + (nn / 10) % 10).toInt()]) {
            return false
        }
        nn /= 10
    }

    return true
}

fun test(nMin: Long, nMax: Long) {
    var k = 0
    for (n in nMin..nMax) {
        if (isStrange(n)) {
            print(n)
            if (++k % 10 != 0) {
                print(' ')
            } else {
                println()
            }
        }
    }
}

fun main() {
    test(101, 499)
}
