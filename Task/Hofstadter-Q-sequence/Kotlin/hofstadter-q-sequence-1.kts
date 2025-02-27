// version 1.1.4

fun main(args: Array<String>) {
    val q = IntArray(100_001)
    q[1] = 1
    q[2] = 1
    for (n in 3..100_000) q[n] = q[n - q[n - 1]] + q[n - q[n - 2]]
    print("The first 10 terms are : ")
    for (i in 1..10) print("${q[i]}  ")
    println("\n\nThe 1000th term is : ${q[1000]}")
    val flips = (2..100_000).count { q[it] < q[it - 1] }
    println("\nThe number of flips for the first 100,000 terms is : $flips")
}
