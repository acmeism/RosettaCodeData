import kotlin.random.Random

fun main() {
    val a = Array(10) { IntArray(10) { Random.nextInt(1..20) } }
    println("array:")
    for (i in a.indices) println("row $i: ${a[i].contentToString()}")

    println("search:")
    outer@ for (i in a.indices) {
        print("row $i:")
        for (j in a[i].indices) {
            print(" " + a[i][j])
            if (a[i][j] == 20) break@outer
        }
        println()
    }
    println()
}
