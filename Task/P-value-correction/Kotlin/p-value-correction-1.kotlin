// version 1.1.51

import java.util.Arrays

typealias IAE = IllegalArgumentException

fun seqLen(start: Int, end: Int) =
    when {
        start == end -> IntArray(end + 1) { it + 1 }
        start < end  -> IntArray(end - start + 1) { start + it }
        else         -> IntArray(start - end + 1) { start - it }
    }

var baseArr: DoubleArray? = null

fun compareIncrease(a: Int, b: Int): Int = baseArr!![b].compareTo(baseArr!![a])

fun compareDecrease(a: Int, b: Int): Int = baseArr!![a].compareTo(baseArr!![b])

fun order(array: DoubleArray, decreasing: Boolean): IntArray {
    val size = array.size
    var idx = IntArray(size) { it }
    baseArr = array.copyOf()
    if (!decreasing) {
        idx = Arrays.stream(idx)
                    .boxed()
                    .sorted { a, b -> compareDecrease(a, b) }
                    .mapToInt { it }
                    .toArray()
    }
    else {
        idx = Arrays.stream(idx)
                    .boxed()
                    .sorted { a, b -> compareIncrease(a, b) }
                    .mapToInt { it }
                    .toArray()
    }
    baseArr = null
    return idx
}

fun cummin(array: DoubleArray): DoubleArray {
    val size = array.size
    if (size < 1) throw IAE("cummin requires at least one element")
    val output = DoubleArray(size)
    var cumulativeMin = array[0]
    for (i in 0 until size) {
        if (array[i] < cumulativeMin) cumulativeMin = array[i]
        output[i] = cumulativeMin
    }
    return output
}

fun cummax(array: DoubleArray): DoubleArray {
    val size = array.size
    if (size < 1) throw IAE("cummax requires at least one element")
    val output = DoubleArray(size)
    var cumulativeMax = array[0]
    for (i in 0 until size) {
        if (array[i] > cumulativeMax) cumulativeMax = array[i]
        output[i] = cumulativeMax
    }
    return output
}

fun pminx(array: DoubleArray, x: Double): DoubleArray {
    val size = array.size
    if (size < 1) throw IAE("pmin requires at least one element")
    return DoubleArray(size) { if (array[it] < x) array[it] else x }
}

fun doubleSay(array: DoubleArray) {
    print("[ 1] %e".format(array[0]))
    for (i in 1 until array.size) {
        print(" %.10f".format(array[i]))
        if ((i + 1) % 5 == 0) print("\n[%2d]".format(i + 1))
    }
    println()
}

fun intToDouble(array: IntArray) = DoubleArray(array.size) { array[it].toDouble() }

fun doubleArrayMin(array: DoubleArray) =
    if (array.size < 1) throw IAE("pAdjust requires at least one element")
    else array.min()!!

fun pAdjust(pvalues: DoubleArray, str: String): DoubleArray {
    val size = pvalues.size
    if (size < 1) throw IAE("pAdjust requires at least one element")
    val type = when(str.toLowerCase()) {
        "bh", "fdr"  -> 0
        "by"         -> 1
        "bonferroni" -> 2
        "hochberg"   -> 3
        "holm"       -> 4
        "hommel"     -> 5
        else         -> throw IAE("'$str' doesn't match any accepted FDR types")
    }
    if (type == 2) {  // Bonferroni method
        return DoubleArray(size) {
            val b = pvalues[it] * size
            when {
                b >= 1           -> 1.0
                0 <= b && b < 1  -> b
                else -> throw RuntimeException("$b is outside [0, 1)")
            }
        }
    }
    else if (type == 4) {  // Holm method
        val o = order(pvalues, false)
        val o2Double = intToDouble(o)
        val cummaxInput = DoubleArray(size) { (size - it) * pvalues[o[it]] }
        val ro = order(o2Double, false)
        val cummaxOutput = cummax(cummaxInput)
        val pmin = pminx(cummaxOutput, 1.0)
        return DoubleArray(size) { pmin[ro[it]] }
    }
    else if (type == 5) { // Hommel method
        val indices = seqLen(size, size)
        val o = order(pvalues, false)
        val p = DoubleArray(size) { pvalues[o[it]] }
        val o2Double = intToDouble(o)
        val ro = order(o2Double, false)
        val q = DoubleArray(size)
        val pa = DoubleArray(size)
        val npi = DoubleArray(size) { p[it] * size / indices[it] }
        val min = doubleArrayMin(npi)
        q.fill(min)
        pa.fill(min)
        for (j in size - 1 downTo 2) {
            val ij = seqLen(1, size - j + 1)
            for (i in 0 until size - j + 1) ij[i]--
            val i2Length = j - 1
            val i2 = IntArray(i2Length) { size - j + 2 + it - 1 }
            val pi2Length = i2Length
            var q1 = j * p[i2[0]] / 2.0
            for (i in 1 until pi2Length) {
                val temp_q1 = p[i2[i]] * j / (2.0 + i)
                if(temp_q1 < q1) q1 = temp_q1
            }
            for (i in 0 until size - j + 1) {
                q[ij[i]] = minOf(p[ij[i]] * j, q1)
            }
            for (i in 0 until i2Length) q[i2[i]] = q[size - j]
            for (i in 0 until size) if (pa[i] < q[i]) pa[i] = q[i]
        }
        for (index in 0 until size) q[index] = pa[ro[index]]
        return q
    }
    val ni = DoubleArray(size)
    val o = order(pvalues, true)
    val oDouble = intToDouble(o)
    for (index in 0 until size) {
        if (pvalues[index] !in 0.0 .. 1.0) {
            throw RuntimeException("array[$index] = ${pvalues[index]} is outside [0, 1]")
        }
        ni[index] = size.toDouble() / (size - index)
    }
    val ro = order(oDouble, false)
    val cumminInput = DoubleArray(size)
    if (type == 0) {  // BH method
        for (index in 0 until size) {
            cumminInput[index] = ni[index] * pvalues[o[index]]
        }
    }
    else if (type == 1) {  // BY method
        var q = 0.0
        for (index in 1 until size + 1) q += 1.0 / index
        for (index in 0 until size) {
            cumminInput[index] = q * ni[index] * pvalues[o[index]]
        }
    }
    else if (type == 3) {  // Hochberg method
        for (index in 0 until size) {
            cumminInput[index] = (index + 1) * pvalues[o[index]]
        }
    }
    val cumminArray = cummin(cumminInput)
    val pmin = pminx(cumminArray, 1.0)
    return DoubleArray(size) { pmin[ro[it]] }
}

fun main(args: Array<String>) {
    val pvalues = doubleArrayOf(
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
    )

    val correctAnswers = listOf(
        doubleArrayOf(  // Benjamini-Hochberg
            6.126681e-01, 8.521710e-01, 1.987205e-01, 1.891595e-01, 3.217789e-01,
            9.301450e-01, 4.870370e-01, 9.301450e-01, 6.049731e-01, 6.826753e-01,
            6.482629e-01, 7.253722e-01, 5.280973e-01, 8.769926e-01, 4.705703e-01,
            9.241867e-01, 6.049731e-01, 7.856107e-01, 4.887526e-01, 1.136717e-01,
            4.991891e-01, 8.769926e-01, 9.991834e-01, 3.217789e-01, 9.301450e-01,
            2.304958e-01, 5.832475e-01, 3.899547e-02, 8.521710e-01, 1.476843e-01,
            1.683638e-02, 2.562902e-03, 3.516084e-02, 6.250189e-02, 3.636589e-03,
            2.562902e-03, 2.946883e-02, 6.166064e-03, 3.899547e-02, 2.688991e-03,
            4.502862e-04, 1.252228e-05, 7.881555e-02, 3.142613e-02, 4.846527e-03,
            2.562902e-03, 4.846527e-03, 1.101708e-03, 7.252032e-02, 2.205958e-02
        ),
        doubleArrayOf(  // Benjamini & Yekutieli
            1.000000e+00, 1.000000e+00, 8.940844e-01, 8.510676e-01, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 5.114323e-01,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.754486e-01, 1.000000e+00, 6.644618e-01,
            7.575031e-02, 1.153102e-02, 1.581959e-01, 2.812089e-01, 1.636176e-02,
            1.153102e-02, 1.325863e-01, 2.774239e-02, 1.754486e-01, 1.209832e-02,
            2.025930e-03, 5.634031e-05, 3.546073e-01, 1.413926e-01, 2.180552e-02,
            1.153102e-02, 2.180552e-02, 4.956812e-03, 3.262838e-01, 9.925057e-02
        ),
        doubleArrayOf(  // Bonferroni
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 7.019185e-01, 1.000000e+00, 1.000000e+00,
            2.020365e-01, 1.516674e-02, 5.625735e-01, 1.000000e+00, 2.909271e-02,
            1.537741e-02, 4.125636e-01, 6.782670e-02, 6.803480e-01, 1.882294e-02,
            9.005725e-04, 1.252228e-05, 1.000000e+00, 4.713920e-01, 4.395577e-02,
            1.088915e-02, 4.846527e-02, 3.305125e-03, 1.000000e+00, 2.867745e-01
        ),
        doubleArrayOf(  // Hochberg
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 4.632662e-01, 9.991834e-01, 9.991834e-01,
            1.575885e-01, 1.383967e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
            1.383967e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
            8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
            1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
        ),
        doubleArrayOf(  // Holm
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00, 1.000000e+00,
            1.000000e+00, 1.000000e+00, 4.632662e-01, 1.000000e+00, 1.000000e+00,
            1.575885e-01, 1.395341e-02, 3.938014e-01, 7.600230e-01, 2.501973e-02,
            1.395341e-02, 3.052971e-01, 5.426136e-02, 4.626366e-01, 1.656419e-02,
            8.825610e-04, 1.252228e-05, 9.930759e-01, 3.394022e-01, 3.692284e-02,
            1.023581e-02, 3.974152e-02, 3.172920e-03, 8.992520e-01, 2.179486e-01
        ),
        doubleArrayOf(  // Hommel
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.987624e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.595180e-01,
            9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01, 9.991834e-01,
            9.991834e-01, 9.991834e-01, 4.351895e-01, 9.991834e-01, 9.766522e-01,
            1.414256e-01, 1.304340e-02, 3.530937e-01, 6.887709e-01, 2.385602e-02,
            1.322457e-02, 2.722920e-01, 5.426136e-02, 4.218158e-01, 1.581127e-02,
            8.825610e-04, 1.252228e-05, 8.743649e-01, 3.016908e-01, 3.516461e-02,
            9.582456e-03, 3.877222e-02, 3.172920e-03, 8.122276e-01, 1.950067e-01
        )
    )
    val types = listOf("bh", "by", "bonferroni", "hochberg", "holm", "hommel")
    val f = "\ntype %d = '%s' has cumulative error of %g"
    for (type in 0 until types.size) {
        val q = pAdjust(pvalues, types[type])
        var error = 0.0
        for (i in 0 until pvalues.size) {
            error += Math.abs(q[i] - correctAnswers[type][i])
        }
        doubleSay(q)
        println(f.format(type, types[type], error))
    }
}
