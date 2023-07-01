// version 1.1.2

fun main(args: Array<String>) {
    println("Police  Sanitation  Fire")
    println("------  ----------  ----")
    var count = 0
    for (i in 2..6 step 2) {
        for (j in 1..7) {
            if (j == i) continue
            for (k in 1..7) {
                if (k == i || k == j) continue
                if (i + j + k != 12) continue
                println("  $i         $j         $k")
                count++
            }
        }
    }
    println("\n$count valid combinations")
}
