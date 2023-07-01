import kotlin.math.sqrt

fun main() {
    println("First 199 terms of the möbius function are as follows:")
    print("    ")
    for (n in 1..199) {
        print("%2d  ".format(mobiusFunction(n)))
        if ((n + 1) % 20 == 0) {
            println()
        }
    }
}

private const val MU_MAX = 1000000
private var MU: IntArray? = null

//  Compute mobius function via sieve
private fun mobiusFunction(n: Int): Int {
    if (MU != null) {
        return MU!![n]
    }

    //  Populate array
    MU = IntArray(MU_MAX + 1)
    val sqrt = sqrt(MU_MAX.toDouble()).toInt()
    for (i in 0 until MU_MAX) {
        MU!![i] = 1
    }
    for (i in 2..sqrt) {
        if (MU!![i] == 1) {
            //  for each factor found, swap + and -
            for (j in i..MU_MAX step i) {
                MU!![j] *= -i
            }
            //  square factor = 0
            for (j in i * i..MU_MAX step i * i) {
                MU!![j] = 0
            }
        }
    }
    for (i in 2..MU_MAX) {
        when {
            MU!![i] == i -> {
                MU!![i] = 1
            }
            MU!![i] == -i -> {
                MU!![i] = -1
            }
            MU!![i] < 0 -> {
                MU!![i] = 1
            }
            MU!![i] > 0 -> {
                MU!![i] = -1
            }
        }
    }
    return MU!![n]
}
