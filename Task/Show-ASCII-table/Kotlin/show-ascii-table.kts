// Version 1.2.60

fun main(args: Array<String>) {
    for (i in 0..15) {
        for (j in 32 + i..127 step 16) {
            val k = when (j) {
                32   -> "Spc"
                127  -> "Del"
                else -> j.toChar().toString()
            }
            System.out.printf("%3d : %-3s   ", j, k)
        }
        println()
    }
}
