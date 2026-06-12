import Foundation

class Node {
    var child: Int = 0
    var sib: Int = 0
    var parent: Int = 0
}

struct Result {
    var pi: [Int]
    var beta: [Int]
    var alfa: [Int]
    var tau: [Int]
    var lam: [Int]
}

// These variables are used to simulate the nonlocal variables
private var p: Int = 0
private var n: Int = 0

func getP() -> Int {
    return p
}

func getN() -> Int {
    return n
}

func process(N: Int, A: [Int]) -> Result {
    var pi = Array(repeating: 0, count: N + 1)
    var beta = Array(repeating: 0, count: N + 1)
    var alfa = Array(repeating: 0, count: N + 1)
    var tau = Array(repeating: 0, count: N + 1)
    var lam = Array(repeating: 0, count: N + 1)
    let nodes = Array(repeating: Node(), count: N + 1)

    // Make triply linked tree
    var t = 0
    for v in stride(from: N, to: 0, by: -1) {
        var u = 0
        while A[v] > A[t] || (A[v] == A[t] && v > t) {
            u = t
            t = nodes[t].parent
        }

        if u != 0 {
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

    while traversal(nodes: nodes, initialP: p, initialN: n, pi: &pi, beta: &beta, tau: &tau, lam: &lam) {
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
    if p != 0 {
        compute_alfa(nodes: nodes, node: p, alfa: &alfa, beta: beta)
    }

    return Result(pi: pi, beta: beta, alfa: alfa, tau: tau, lam: lam)
}

func traversal(nodes: [Node], initialP: Int, initialN: Int, pi: inout [Int], beta: inout [Int], tau: inout [Int], lam: inout [Int]) -> Bool {
    p = initialP
    n = initialN

    // s3: Compute beta in the easy case
    while true {
        n += 1
        pi[p] = n
        tau[n] = 0
        lam[n] = 1 + lam[n >> 1]

        if nodes[p].child != 0 {
            p = nodes[p].child
            continue
        }

        beta[p] = n
        break
    }

    // s4: Compute tau, bottom-up
    while true {
        tau[beta[p]] = nodes[p].parent

        if nodes[p].sib != 0 {
            p = nodes[p].sib
            return true  // Go back to s3
        }

        p = nodes[p].parent

        // Compute beta in the hard case
        if p != 0 {
            let h = lam[n & -pi[p]]
            beta[p] = ((n >> h) | 1) << h
        } else {
            return false  // Exit traversal
        }
    }
}

func compute_alfa(nodes: [Node], node: Int, alfa: inout [Int], beta: [Int]) {
    // s7: Compute alfa, top-down
    alfa[node] = alfa[nodes[node].parent] | (beta[node] & -beta[node])

    if nodes[node].child != 0 {
        compute_alfa(nodes: nodes, node: nodes[node].child, alfa: &alfa, beta: beta)
    }

    // s8: Continue traversal
    if nodes[node].sib != 0 {
        compute_alfa(nodes: nodes, node: nodes[node].sib, alfa: &alfa, beta: beta)
    }
}

func nca(x: Int, y: Int, beta: [Int], alfa: [Int], tau: [Int], lam: [Int], pi: [Int]) -> Int {
    // Find common height
    var h: Int
    if beta[x] <= beta[y] {
        h = lam[beta[y] & -beta[x]]
    } else {
        h = lam[beta[x] & -beta[y]]
    }

    // Find true height
    let k = alfa[x] & alfa[y] & -(1 << h)
    h = lam[k & -k]

    // Find beta[z]
    let j = ((beta[x] >> h) | 1) << h

    // Find x' and y'
    var x = x
    var y = y

    if j != beta[x] {
        let l = lam[alfa[x] & ((1 << h) - 1)]
        x = tau[((beta[x] >> l) | 1) << l]
    }

    if j != beta[y] {
        let l = lam[alfa[y] & ((1 << h) - 1)]
        y = tau[((beta[y] >> l) | 1) << l]
    }

    // Find z
    let z = (pi[x] <= pi[y]) ? x : y
    return z
}

func solve_test_case(n: Int, values: [Int], queries: [[Int]]) -> [Int] {
    var results: [Int] = []

    var A = Array(repeating: 0, count: n + 2)
    A[0] = Int.max  // A[0]
    var R = Array(repeating: 0, count: n + 2)
    var B = Array(repeating: 0, count: n + 2)

    var N = 1
    var count = 0
    var oldx: Int? = nil

    for i in 1...n {
        let x = values[i - 1]

        if i > 1 && (oldx == nil || x != oldx!) {
            A[N] = count
            R[N] = i
            N += 1
            count = 0
        }

        B[i] = N
        count += 1
        oldx = x
    }

    A[N] = count
    R[N] = n + 1

    let result = process(N: N, A: A)
    let pi = result.pi
    let beta = result.beta
    let alfa = result.alfa
    let tau = result.tau
    let lam = result.lam

    for query in queries {
        let i = query[0]
        let j = query[1]
        let x = B[i]
        let y = B[j]

        var z: Int
        if x == y {
            z = j - i + 1
        } else {
            if x + 1 != y {
                z = A[nca(x: x + 1, y: y - 1, beta: beta, alfa: alfa, tau: tau, lam: lam, pi: pi)]
            } else {
                z = 0
            }

            z = max(z, max(R[x] - i, A[y] - R[y] + j + 1))
        }

        results.append(z)
    }

    return results
}

struct TestCase {
    let n: Int
    let values: [Int]
    let queries: [[Int]]
    let expected: [Int]

    init(n: Int, values: [Int], queries: [[Int]], expected: [Int]) {
        self.n = n
        self.values = values
        self.queries = queries
        self.expected = expected
    }
}

// Main program
func main() {
    // Hard-coded test data
    let testCases: [TestCase] = [
        TestCase(
            n: 10,
            values: [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
            queries: [[2, 3], [1, 10], [5, 10]],
            expected: [1, 4, 3]
        )
    ]

    for (idx, test) in testCases.enumerated() {
        let n = test.n
        let values = test.values
        let queries = test.queries
        let expected = test.expected

        print("Test Case \(idx + 1):")
        print("Size: \(n), Queries: \(queries.count)")
        print("Values: \(values.map { String($0) }.joined(separator: " "))")

        let results = solve_test_case(n: n, values: values, queries: queries)

        print("Queries and Results:")
        for q_idx in 0..<queries.count {
            let query = queries[q_idx]
            let result = results[q_idx]
            let exp = expected[q_idx]

            print("Query: \(query[0]) \(query[1])")
            print("Result: \(result) (Expected: \(exp))")
            if result != exp {
                print("  WARNING: Result doesn't match expected output")
            }
        }

        print()
    }
}

main()
