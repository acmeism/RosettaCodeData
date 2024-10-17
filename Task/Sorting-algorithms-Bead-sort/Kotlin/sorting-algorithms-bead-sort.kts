// version 1.1.2

fun beadSort(a: IntArray) {
    val n = a.size
    if (n < 2) return
    var max = a.max()!!
    val beads = ByteArray(max * n)
    /* mark the beads */
    for (i in 0 until n)
        for (j in 0 until a[i])
            beads[i * max + j] = 1

    for (j in 0 until max) {
        /* count how many beads are on each post */
        var sum = 0
        for (i in 0 until n) {
            sum += beads[i * max + j]
            beads[i * max + j] = 0
        }
        /* mark bottom sum beads */
        for (i in n - sum until n) beads[i * max + j] = 1
    }

    for (i in 0 until n) {
        var j = 0
        while (j < max && beads[i * max + j] == 1.toByte()) j++
        a[i] = j
    }
}

fun main(args: Array<String>) {
    val a  = intArrayOf(5, 3, 1, 7, 4, 1, 1, 20)
    println("Before sorting : ${a.contentToString()}")
    beadSort(a)
    println("After sorting  : ${a.contentToString()}")
}
