// version 1.1.2

val rand = java.util.Random()

fun normalStats(sampleSize: Int) {
    if (sampleSize < 1) return
    val r = DoubleArray(sampleSize)
    val h = IntArray(12) // all zero by default
    /*
       Generate 'sampleSize' normally distributed random numbers with mean 0.5 and SD 0.25
       and calculate in which box they will fall when drawing the histogram
    */
    for (i in 0 until sampleSize) {
        r[i] = 0.5 + rand.nextGaussian() / 4.0
        when {
            r[i] <  0.0 -> h[0]++
            r[i] >= 1.0 -> h[11]++
            else        -> h[1 + (r[i] * 10).toInt()]++
        }
    }

    // adjust one of the h[] values if necessary to ensure they sum to sampleSize
    val adj = sampleSize - h.sum()
    if (adj != 0) {
        for (i in 0..11) {
            h[i] += adj
            if (h[i] >= 0) break
            h[i] -= adj
        }
    }

    val mean = r.average()
    val sd = Math.sqrt(r.map { (it - mean) * (it - mean) }.average())

    // Draw a histogram of the data with interval 0.1
    var numStars: Int
    // If sample size > 300 then normalize histogram to 300
    val scale = if (sampleSize <= 300) 1.0 else 300.0 / sampleSize
    println("Sample size $sampleSize\n")
    println("  Mean ${"%1.6f".format(mean)}  SD ${"%1.6f".format(sd)}\n")
    for (i in 0..11) {
        when (i) {
            0    -> print("< 0.00 : ")
            11   -> print(">=1.00 : ")
            else -> print("  %1.2f : ".format(i / 10.0))
        }
        print("%5d ".format(h[i]))
        numStars = (h[i] * scale + 0.5).toInt()
        println("*".repeat(numStars))
    }
    println()
}

fun main(args: Array<String>) {
    val sampleSizes = intArrayOf(100, 1_000, 10_000, 100_000)
    for (sampleSize in sampleSizes) normalStats(sampleSize)
}
