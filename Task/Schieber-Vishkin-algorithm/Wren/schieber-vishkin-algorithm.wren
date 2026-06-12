import "./dynamic" for Struct
import "./math" for Math

var Node = Struct.create("Node", ["child", "sib", "parent"])

var Result = Struct.create("Result", ["pi", "beta", "alfa", "tau", "lam"])

var process = Fn.new { |N, A|
    var pi    = List.filled(N + 1, 0)
    var beta  = List.filled(N + 1, 0)
    var alfa  = List.filled(N + 1, 0)
    var tau   = List.filled(N + 1, 0)
    var lam   = List.filled(N + 1, 0)
    var nodes = List.filled(N + 1, null)
    for (i in 0..N) nodes[i] = Node.new(0, 0, 0)

    // Make triply linked tree.
    var t = 0
    for (v in N..1) {
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

    // Begin first traversal.
    var p = nodes[0].child
    var n = 0
    lam[0] = -1

    var traversal = Fn.new {
        // s3: Compute beta in the easy case.
        while (true) {
            n = n + 1
            pi[p] = n
            tau[n] = 0
            lam[n] = 1 + lam[n >> 1]

            if (nodes[p].child != 0) {
                p = nodes[p].child
                continue
            }

            beta[p] = n
            break
        }

        // s4: Compute tau, bottom-up.
        while (true) {
            tau[beta[p]] = nodes[p].parent

            if (nodes[p].sib != 0) {
                p = nodes[p].sib
                return true  // go back to s3
            }

            p = nodes[p].parent

            // Compute beta in the hard case.
            if (p != 0) {
                var h = lam[n & ~(pi[p] - 1)]
                beta[p] = ((n >> h) | 1) << h
            } else {
                return false  // exit traversal
            }
        }
    }

    // Perform first traversal.
    while (traversal.call()) {}

    // Begin second traversal.
    p = nodes[0].child
    lam[0] = lam[n]
    pi[0] = beta[0] = alfa[0] = 0

    var computeAlfa // recursive
    computeAlfa = Fn.new { |node|
        // s7: Compute alfa, top-down.
        alfa[node] = alfa[nodes[node].parent] | (beta[node] & ~(beta[node] - 1))

        if (nodes[node].child != 0) computeAlfa.call(nodes[node].child)

        // s8: Continue traversal.
        if (nodes[node].sib != 0) computeAlfa.call(nodes[node].sib)
    }

    // Perform second traversal.
    if (p != 0) computeAlfa.call(p)

    return Result.new(pi, beta, alfa, tau, lam)
}

var nca = Fn.new { |x, y, beta, alfa, tau, lam, pi|
    // Find common height.
    var h
    if (beta[x] <= beta[y]) {
        h = lam[beta[y] & ~(beta[x] - 1)]
    } else {
        h = lam[beta[x] & ~(beta[y] - 1)]
    }

    // Find true height.
    var k = alfa[x] & alfa[y] & ~((1 << h) - 1)
    h = lam[k & ~(k - 1)]

    // Find beta[z].
    var j = ((beta[x] >> h) | 1) << h

    // Find x' and y'.
    var l
    if (j != beta[x]) {
        l = lam[alfa[x] & ((1 << h) - 1)]
        x = tau[((beta[x] >> l) | 1) << l]
    }

    if (j != beta[y]) {
        l = lam[alfa[y] & ((1 << h) - 1)]
        y = tau[((beta[y] >> l) | 1) << l]
    }

    // Find z.
    var z = pi[x] <= pi[y] ? x : y
    return z
}

var solveTestCase = Fn.new { |n, values, queries|
    var results = []

    var A = [Num.maxSafeInteger]
    var R = List.filled(n + 2, 0)
    var B = List.filled(n + 2, 0)

    var N = 1
    var count = 0
    var oldx = null

    for (i in 1..n) {
        var x = values[i - 1]

        if (i > 1 && x != oldx) {
            A.add(count)
            R[N] = i
            N = N + 1
            count = 0
        }

        B[i] = N
        count = count + 1
        oldx = x
    }

    A.add(count)
    R[N] = n + 1

    var r = process.call(N, A)

    for (t in queries) {
        var i = t[0]
        var j = t[1]
        var x = B[i]
        var y = B[j]
        var z

        if (x == y) {
            z = j - i + 1
        } else {
            if (x + 1 != y) {
                z = A[nca.call(x + 1, y - 1, r.beta, r.alfa, r.tau, r.lam, r.pi)]
            } else {
                z = 0
            }
            z = Math.max(z, Math.max(R[x] - i, A[y] - R[y] + j + 1))
        }
        results.add(z)
    }
    return results
}

// Hard-coded test data.
var testCases = [
    {
        "n": 10,
        "values": [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
        "queries": [[2, 3], [1, 10], [5, 10]],
        "expected": [1, 4, 3]
    }
]

var idx = 0
for (test in testCases) {
    var n = test["n"]
    var values = test["values"]
    var queries = test["queries"]
    var expected = test["expected"]

    System.print("Test Case %(idx + 1):")
    System.print("Size: %(n), Queries: %(queries.count)")
    System.print("Values: %(values.join(" "))")

    var results = solveTestCase.call(n, values, queries)

    System.print("Queries and Results:")
    for (qIdx in 0...queries.count) {
        var q = queries[qIdx]
        var i = q[0]
        var j = q[1]
        var result = results[qIdx]
        var exp = expected[qIdx]
        System.print("Query: %(i) %(j)")
        System.print("Result: %(result) (Expected: %(exp))")
        if (result != exp) {
            System.print("  WARNING: Result doesn't match expected output")
        }
    }
    idx = idx + 1
    System.print()
}
