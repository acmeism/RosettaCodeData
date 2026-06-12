// version 1.1

fun twoSum(a: IntArray, targetSum: Int): Pair<Int, Int>? {
    if (a.size < 2) return null
    var sum: Int
    for (i in 0..a.size - 2) {
        if (a[i] <= targetSum) {
            for (j in i + 1..a.size - 1) {
                sum = a[i] + a[j]
                if (sum == targetSum) return Pair(i, j)
                if (sum > targetSum) break
            }
        } else {
            break
        }
    }
    return null
}

fun main(args: Array<String>) {
    val a = intArrayOf(0, 2, 11, 19, 90)
    val targetSum = 21
    val p = twoSum(a, targetSum)
    if (p == null) {
        println("No two numbers were found whose sum is $targetSum")
    } else {
        println("The numbers with indices ${p.first} and ${p.second} sum to $targetSum")
    }
}
