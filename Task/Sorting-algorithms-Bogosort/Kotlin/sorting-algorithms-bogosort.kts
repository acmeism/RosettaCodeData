// version 1.1.2

const val RAND_MAX = 32768 // big enough for this

val rand = java.util.Random()

fun isSorted(a: IntArray): Boolean {
    val n = a.size
    if (n < 2) return true
    for (i in 1 until n) {
        if (a[i] < a[i - 1]) return false
    }
    return true
}

fun shuffle(a: IntArray) {
    val n = a.size
    if (n < 2) return
    for (i in 0 until n) {
        val t = a[i]
        val r = rand.nextInt(RAND_MAX) % n
        a[i] = a[r]
        a[r] = t
    }
}

fun bogosort(a: IntArray) {
   while (!isSorted(a)) shuffle(a)
}

fun main(args: Array<String>) {
    val a = intArrayOf(1, 10, 9,  7, 3, 0)
    println("Before sorting : ${a.contentToString()}")
    bogosort(a)
    println("After sorting  : ${a.contentToString()}")
}
