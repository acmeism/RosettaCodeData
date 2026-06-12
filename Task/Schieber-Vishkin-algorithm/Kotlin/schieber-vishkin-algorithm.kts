import java.util.*

data class Node(
    var child: Int = 0,
    var sib: Int = 0,
    var parent: Int = 0
)

data class Result(
    val pi: IntArray,
    val beta: IntArray,
    val alfa: IntArray,
    val tau: IntArray,
    val lam: IntArray
)

data class TestCase(
    val n: Int,
    val values: IntArray,
    val queries: Array<IntArray>,
    val expected: IntArray
)

class CodeKt{
    // These variables are used to simulate the nonlocal variables in Python
    private var p = 0
    private var n = 0

    private fun getP(): Int = p
    private fun getN(): Int = n

    fun process(N: Int, A: IntArray): Result {
        val pi = IntArray(N + 1)
        val beta = IntArray(N + 1)
        val alfa = IntArray(N + 1)
        val tau = IntArray(N + 1)
        val lam = IntArray(N + 1)
        val nodes = Array(N + 1) { Node() }

        // Make triply linked tree
        var t = 0
        for (v in N downTo 1) {
            var u = 0
            while (A[v] > A[t] || (A[v] == A[t] && v > t)) {
                u = t
                t = nodes[t].parent
            }

            if (u != 0) {
                nodes[v].sib = nodes[u].sib
                nodes[u].sib = 0
                nodes[u].parent = v
                nodes[v].child = u
            } else {
                nodes[v].sib = nodes[t].child
            }

            nodes[t].child = v
            nodes[v].parent = t
            t = v
        }

        // Begin first traversal
        var p = nodes[0].child
        var n = 0
        lam[0] = -1

        while (traversal(nodes, p, n, pi, beta, tau, lam)) {
            // Continue traversal
            n = getN()
            p = getP()
        }

        // Begin second traversal
        p = nodes[0].child
        lam[0] = lam[n]
        pi[0] = 0
        beta[0] = 0
        alfa[0] = 0

        // Perform second traversal
        if (p != 0) {
            computeAlfa(nodes, p, alfa, beta)
        }

        return Result(pi, beta, alfa, tau, lam)
    }

    fun traversal(nodes: Array<Node>, initialP: Int, initialN: Int, pi: IntArray, beta: IntArray, tau: IntArray, lam: IntArray): Boolean {
        p = initialP
        n = initialN

        // s3: Compute beta in the easy case
        while (true) {
            n++
            pi[p] = n
            tau[n] = 0
            lam[n] = 1 + lam[n shr 1]

            if (nodes[p].child != 0) {
                p = nodes[p].child
                continue
            }

            beta[p] = n
            break
        }

        // s4: Compute tau, bottom-up
        while (true) {
            tau[beta[p]] = nodes[p].parent

            if (nodes[p].sib != 0) {
                p = nodes[p].sib
                return true  // Go back to s3
            }

            p = nodes[p].parent

            // Compute beta in the hard case
            if (p != 0) {
                val h = lam[n and -pi[p]]
                beta[p] = ((n shr h) or 1) shl h
            } else {
                return false  // Exit traversal
            }
        }
    }

    fun computeAlfa(nodes: Array<Node>, node: Int, alfa: IntArray, beta: IntArray) {
        // s7: Compute alfa, top-down
        alfa[node] = alfa[nodes[node].parent] or (beta[node] and -beta[node])

        if (nodes[node].child != 0) {
            computeAlfa(nodes, nodes[node].child, alfa, beta)
        }

        // s8: Continue traversal
        if (nodes[node].sib != 0) {
            computeAlfa(nodes, nodes[node].sib, alfa, beta)
        }
    }

    fun nca(x: Int, y: Int, beta: IntArray, alfa: IntArray, tau: IntArray, lam: IntArray, pi: IntArray): Int {
        // Find common height
        val h = if (beta[x] <= beta[y]) {
            lam[beta[y] and -beta[x]]
        } else {
            lam[beta[x] and -beta[y]]
        }

        // Find true height
        val k = alfa[x] and alfa[y] and -(1 shl h)
        val trueH = lam[k and -k]

        // Find beta[z]
        val j = ((beta[x] shr trueH) or 1) shl trueH

        // Find x' and y'
        var newX = x
        var newY = y

        if (j != beta[x]) {
            val l = lam[alfa[x] and ((1 shl trueH) - 1)]
            newX = tau[((beta[x] shr l) or 1) shl l]
        }

        if (j != beta[y]) {
            val l = lam[alfa[y] and ((1 shl trueH) - 1)]
            newY = tau[((beta[y] shr l) or 1) shl l]
        }

        // Find z
        return if (pi[newX] <= pi[newY]) newX else newY
    }

    fun solveTestCase(n: Int, values: IntArray, queries: Array<IntArray>): List<Int> {
        val results = mutableListOf<Int>()

        val A = IntArray(n + 2)
        A[0] = Int.MAX_VALUE  // A[0]
        val R = IntArray(n + 2)
        val B = IntArray(n + 2)

        var N = 1
        var count = 0
        var oldX: Int? = null

        for (i in 1..n) {
            val x = values[i - 1]

            if (i > 1 && (oldX == null || x != oldX)) {
                A[N] = count
                R[N] = i
                N++
                count = 0
            }

            B[i] = N
            count++
            oldX = x
        }

        A[N] = count
        R[N] = n + 1

        val result = process(N, A)
        val pi = result.pi
        val beta = result.beta
        val alfa = result.alfa
        val tau = result.tau
        val lam = result.lam

        for (query in queries) {
            val i = query[0]
            val j = query[1]
            val x = B[i]
            val y = B[j]

            val z = if (x == y) {
                j - i + 1
            } else {
                val commonAncestorValue = if (x + 1 != y) {
                    A[nca(x + 1, y - 1, beta, alfa, tau, lam, pi)]
                } else {
                    0
                }

                maxOf(commonAncestorValue, maxOf(R[x] - i, A[y] - R[y] + j + 1))
            }

            results.add(z)
        }

        return results
    }

    @JvmStatic
    fun main(args: Array<String>) {
        // Hard-coded test data
        val testCases = listOf(
            TestCase(
                10,
                intArrayOf(-1, -1, 1, 1, 1, 1, 3, 10, 10, 10),
                arrayOf(
                    intArrayOf(2, 3),
                    intArrayOf(1, 10),
                    intArrayOf(5, 10)
                ),
                intArrayOf(1, 4, 3)
            )
        )

        for ((idx, test) in testCases.withIndex()) {
            val n = test.n
            val values = test.values
            val queries = test.queries
            val expected = test.expected

            println("Test Case ${idx + 1}:")
            println("Size: $n, Queries: ${queries.size}")
            print("Values: ")
            values.forEach { print("$it ") }
            println()

            val results = solveTestCase(n, values, queries)

            println("Queries and Results:")
            for (qIdx in queries.indices) {
                val query = queries[qIdx]
                val result = results[qIdx]
                val exp = expected[qIdx]

                println("Query: ${query[0]} ${query[1]}")
                println("Result: $result (Expected: $exp)")
                if (result != exp) {
                    println("  WARNING: Result doesn't match expected output")
                }
            }

            println()
        }
    }
}
