// version 1.1.2

fun <T> ncs(a: Array<T>) {
    fun generate(m: Int, k: Int, c: IntArray) {
        if (k == m) {
            if (c[m - 1] != c[0] + m - 1) {
                for (i in 0 until m)  print("${a[c[i]]} ")
                println()
            }
        }
        else {
            for (j in 0 until a.size) {
                if (k == 0 || j > c[k - 1]) {
                    c[k] = j
                    generate(m, k + 1, c)
                }
            }
        }
    }

    for (m in 2 until a.size) {
        val c = IntArray(m)
        generate(m, 0, c)
    }
}

fun main(args: Array<String>) {
    val a = arrayOf(1, 2, 3, 4)
    ncs(a)
    println()
    val ca = arrayOf('a', 'b', 'c', 'd', 'e')
    ncs(ca)
}
