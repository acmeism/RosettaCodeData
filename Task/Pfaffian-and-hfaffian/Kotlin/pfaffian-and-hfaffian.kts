import java.util.*

object MainKt {

    @JvmStatic
    fun main(args: Array<String>) {
        val matrices = listOf(
            arrayOf(
                intArrayOf(0, 1),
                intArrayOf(-1, 0)
            ),
            arrayOf(
                intArrayOf(0, 1, -1, 2),
                intArrayOf(-1, 0, 3, -4),
                intArrayOf(1, -3, 0, 5),
                intArrayOf(-2, 4, -5, 0)
            ),
            arrayOf(
                intArrayOf(1, 2, 3, 4, 5, 6),
                intArrayOf(2, 7, 8, 9, 10, 11),
                intArrayOf(3, 8, 12, 13, 14, 15),
                intArrayOf(4, 9, 13, 16, 17, 18),
                intArrayOf(5, 10, 14, 17, 19, 20),
                intArrayOf(6, 11, 15, 18, 20, 21)
            ),
            arrayOf(
                intArrayOf(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
                intArrayOf(-1, 0, 8, 7, 6, 5, 4, 3, 2, 1),
                intArrayOf(-2, -8, 0, 1, 2, 3, 4, 5, 6, 7),
                intArrayOf(-3, -7, -1, 0, 6, 5, 4, 3, 2, 1),
                intArrayOf(-4, -6, -2, -6, 0, 1, 2, 3, 4, 5),
                intArrayOf(-5, -5, -3, -5, -1, 0, 4, 3, 2, 1),
                intArrayOf(-6, -4, -4, -4, -2, -4, 0, 1, 2, 3),
                intArrayOf(-7, -3, -5, -3, -3, -3, -1, 0, 2, 1),
                intArrayOf(-8, -2, -6, -2, -4, -2, -2, -2, 0, 1),
                intArrayOf(-9, -1, -7, -1, -5, -1, -3, -1, -1, 0)
            )
        )

        matrices.forEach { matrix ->
            printMatrix(matrix)
            for (faffian in Faffian.values()) {
                val result = computeFaffian(matrix, faffian)
                if (result.isPresent) {
                    println("${faffian}: ${result.get()}")
                }
            }
            println()
        }
    }

    private fun computeFaffian(matrix: Array<IntArray>, faffian: Faffian): Optional<Long> {
        if (matrix.size % 2 != 0) {
            println("Matrix size must be even for $faffian")
            return Optional.empty()
        }

        if (!isAntisymmetric(matrix)) {
            println("The $faffian does not support non-antisymmetric matrices")
            return Optional.empty()
        }

        val n = matrix.size / 2
        var sum = 0
        val signedPerms = signedPermutations(2 * n - 1)
        for (signedPerm in signedPerms) {
            val sigma = signedPerm.permutation
            val sign = if (faffian == Faffian.Pfaffian) signedPerm.sign else 1
            var product = 1
            for (i in 0 until n) {
                product *= matrix[sigma[2 * i]][sigma[2 * i + 1]]
            }
            sum += sign * product
        }

        val normalization = 1.0 / factorial(n) / Math.pow(2.0, n.toDouble())
        return Optional.of(Math.round(sum * normalization))
    }

    private fun signedPermutations(n: Int): List<SignedPerm> {
        val perms = MutableList(n + 1) { it }
        val signedPerms = mutableListOf(SignedPerm(ArrayList(perms), 1))
        var sign = 1
        for (k in 1 until factorial(n + 1)) {
            var i = n - 1
            var j = n
            while (perms[i] > perms[i + 1]) {
                i -= 1
            }
            while (perms[j] < perms[i]) {
                j -= 1
            }
            swap(perms, i, j)
            sign = -sign
            i += 1
            j = n
            while (i < j) {
                swap(perms, i, j)
                sign = -sign
                i += 1
                j -= 1
            }
            signedPerms.add(SignedPerm(ArrayList(perms), sign))
        }
        return signedPerms
    }

    private fun isAntisymmetric(matrix: Array<IntArray>): Boolean {
        for (i in matrix.indices) {
            if (matrix[i][i] != 0) {
                return false
            }
            for (j in i + 1 until matrix.size) {
                if (matrix[i][j] != -matrix[j][i]) {
                    return false
                }
            }
        }
        return true
    }

    private fun factorial(n: Int): Int {
        var factorial = 1
        for (i in 2..n) {
            factorial *= i
        }
        return factorial
    }

    private fun swap(list: MutableList<Int>, i: Int, j: Int) {
        val temp = list[i]
        list[i] = list[j]
        list[j] = temp
    }

    private fun printMatrix(matrix: Array<IntArray>) {
        for (row in matrix) {
            print("|")
            for (i in 0 until row.size - 1) {
                print("%2d, ".format(row[i]))
            }
            println("%2d|".format(row[row.size - 1]))
        }
    }

    private data class SignedPerm(val permutation: List<Int>, val sign: Int)

    private enum class Faffian {
        Pfaffian, Hfaffian
    }
}

