// version 1.1.2

val data = intArrayOf(
    85, 88, 75, 66, 25, 29, 83, 39, 97,
    68, 41, 10, 49, 16, 65, 32, 92, 28, 98
)

fun pick(at: Int, remain: Int, accu: Int, treat: Int): Int {
    if (remain == 0) return if (accu > treat) 1 else 0
    return pick(at - 1, remain - 1, accu + data[at - 1], treat) +
           if (at > remain) pick(at - 1, remain, accu, treat) else 0
}

fun main(args: Array<String>) {
    var treat = 0
    var total = 1.0
    for (i in 0..8) treat += data[i]
    for (i in 19 downTo 11) total *= i
    for (i in 9 downTo 1) total /= i
    val gt = pick(19, 9, 0, treat)
    val le = (total - gt).toInt()
    System.out.printf("<= : %f%%  %d\n", 100.0 * le / total, le)
    System.out.printf(" > : %f%%  %d\n", 100.0 * gt / total, gt)
}
