fun main() {
    val source = listOf(0, 1, 1, 2, 3, 5, 8, 13, 21)
    val bm = BerlekampMassey(source, 100)
    val bmCoeffs = bm.computeCoefficients()
    println("Berlekamp-Massey coefficients: $bmCoeffs (lowest to highest degree)")
    println("The connection polynomial is ${bm.polynomial(bmCoeffs)} having degree ${bmCoeffs.size - 1}\n")

    println("Terms indexed 35 to 40 from the Fibonacci sequence modulo 100:")
    // Result can be checked on www.oeis.net, A000045
    listOf(35, 36, 37, 38, 39, 40).forEach { n ->
        print("${bm.computeTerm(bmCoeffs, n)} ")
    }
}

class BerlekampMassey(private val source: List<Int>, private val modulus: Int) {

    fun computeCoefficients(): List<Int> {
        val result = mutableListOf<Int>()
        var previousResult = mutableListOf<Int>()
        var failIndex = -1

        for (i in source.indices) {
            var delta = source[i]
            for (j in 1..result.size) {
                delta -= result[j - 1] * source[i - j]
            }
            if (delta == 0) {
                continue
            }
            if (failIndex == -1) {
                result.clear()
                result.addAll(List(i + 1) { 0 })
                failIndex = i
            } else {
                val previousResultCopy = mutableListOf<Int>()
                previousResultCopy.add(1)
                for (term in previousResult) {
                    previousResultCopy.add(-term)
                }

                var termFailIndexPlusOne = 0
                for (j in 1..previousResultCopy.size) {
                    termFailIndexPlusOne += previousResultCopy[j - 1] * source[failIndex + 1 - j]
                }

                val coeff = delta / termFailIndexPlusOne
                for (k in previousResultCopy.indices) {
                    previousResultCopy[k] = previousResultCopy[k] * coeff
                }

                repeat(i - failIndex - 1) {
                    previousResultCopy.add(0, 0)
                }

                val resultCopy = result.toMutableList()
                while (result.size < previousResultCopy.size) {
                    result.add(0)
                }

                for (j in previousResultCopy.indices) {
                    result[j] = result[j] + previousResultCopy[j]
                }

                if (i - resultCopy.size > failIndex - previousResult.size) {
                    previousResult = resultCopy
                    failIndex = i
                }
            }
        }
        return result
    }

    fun computeTerm(bmCoeffs: List<Int>, index: Int): Int {
        if (bmCoeffs.isEmpty()) {
            return 0
        }

        if (index < source.size) {
            return (source[index] + modulus) % modulus
        }

        val coeffs = mutableListOf<Int>()
        coeffs.add(modulus - 1)
        coeffs.addAll(bmCoeffs)

        val bmCoeffsSize = bmCoeffs.size
        val f = MutableList(bmCoeffsSize) { 0 }
        var g = MutableList(bmCoeffsSize) { 0 }
        f[0] = 1

        if (bmCoeffsSize == 1) {
            g[0] = coeffs[1]
        } else {
            g[1] = 1
        }

        var power = index - 1
        while (power > 0) {
            if ((power and 1) == 1) {
                val newF = polynomialMultiply(f, g, bmCoeffsSize, coeffs)
                f.clear()
                f.addAll(newF)
            }
            g = polynomialMultiply(g, g, bmCoeffsSize, coeffs).toMutableList()
            power = power shr 1
        }

        var result = 0
        for (i in 0 until bmCoeffsSize) {
            if (i + 1 < source.size) {
                result = (result + source[i + 1] * f[i]) % modulus
            }
        }
        return (result + modulus) % modulus
    }

    fun polynomial(bmCoeffs: List<Int>): String {
        val degree = bmCoeffs.size - 1
        if (degree == 0) {
            return bmCoeffs.first().toString()
        }

        val text = StringBuilder()
        for (i in degree downTo 0) {
            val coeff = bmCoeffs[i]
            if (coeff == 0) {
                continue
            }

            val sign = when {
                coeff < 0 && i == degree -> "-"
                coeff < 0 -> " - "
                i < degree -> " + "
                else -> ""
            }
            text.append(sign)

            val coeffAbs = kotlin.math.abs(coeff)
            if (coeffAbs > 1) {
                text.append(coeffAbs)
            }

            val term = when {
                i > 1 -> "x^$i"
                i == 1 -> "x"
                coeffAbs == 1 -> "1"
                else -> ""
            }
            text.append(term)
        }
        return text.toString()
    }

    private fun polynomialMultiply(
        a: List<Int>,
        b: List<Int>,
        degree: Int,
        coeffs: List<Int>
    ): List<Int> {
        val result = MutableList(2 * degree) { 0 }

        for (i in 0 until degree) {
            if (a[i] == 0) {
                continue
            }
            for (j in 0 until degree) {
                result[i + j] = (result[i + j] + a[i] * b[j]) % modulus
            }
        }

        for (i in 2 * degree - 1 downTo degree) {
            if (result[i] == 0) {
                continue
            }
            val term = result[i]
            result[i] = 0
            for (j in 0..degree) {
                val index = i - j
                if (index >= 0) {
                    result[index] = (result[index] + term * coeffs[j]) % modulus
                }
            }
        }

        return result.subList(0, degree)
    }
}
