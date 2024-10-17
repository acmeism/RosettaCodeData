// version 1.1.3

fun filter(a: DoubleArray, b: DoubleArray, signal: DoubleArray): DoubleArray {
    val result = DoubleArray(signal.size)
    for (i in 0 until signal.size) {
        var tmp = 0.0
        for (j in 0 until b.size) {
            if (i - j < 0) continue
            tmp += b[j] * signal[i - j]
        }
        for (j in 1 until a.size) {
            if (i - j < 0) continue
            tmp -= a[j] * result[i - j]
        }
        tmp /= a[0]
        result[i] = tmp
    }
    return result
}

fun main(args: Array<String>) {
    val a = doubleArrayOf(1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17)
    val b = doubleArrayOf(0.16666667, 0.5, 0.5, 0.16666667)

    val signal = doubleArrayOf(
        -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412,
        -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044,
        0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,
        0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,
        0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589
    )

    val result = filter(a, b, signal)
    for (i in 0 until result.size) {
        print("% .8f".format(result[i]))
        print(if ((i + 1) % 5 != 0) ", " else "\n")
    }
}
