import sys
from typing import List, Tuple

class Node:
    def __init__(self):
        self.child = 0
        self.sib = 0
        self.parent = 0

def process(N: int, A: List[int]) -> Tuple[List[int], List[int], List[int], List[int], List[int]]:
    pi = [0] * (N + 1)
    beta = [0] * (N + 1)
    alfa = [0] * (N + 1)
    tau = [0] * (N + 1)
    lam = [0] * (N + 1)
    nodes = [Node() for _ in range(N + 1)]

    # Make triply linked tree
    t = 0
    for v in range(N, 0, -1):
        u = 0
        while A[v] > A[t] or (A[v] == A[t] and v > t):
            u = t
            t = nodes[t].parent

        if u:
            nodes[v].sib = nodes[u].sib
            nodes[u].sib = 0
            nodes[u].parent = v
            nodes[v].child = u
        else:
            nodes[v].sib = nodes[t].child

        nodes[t].child = v
        nodes[v].parent = t
        t = v

    # Begin first traversal
    p = nodes[0].child
    n = 0
    lam[0] = -1

    def traversal():
        nonlocal p, n

        # s3: Compute beta in the easy case
        while True:
            n += 1
            pi[p] = n
            tau[n] = 0
            lam[n] = 1 + lam[n >> 1]

            if nodes[p].child:
                p = nodes[p].child
                continue

            beta[p] = n
            break

        # s4: Compute tau, bottom-up
        while True:
            tau[beta[p]] = nodes[p].parent

            if nodes[p].sib:
                p = nodes[p].sib
                return True  # Go back to s3

            p = nodes[p].parent

            # Compute beta in the hard case
            if p:
                h = lam[n & -pi[p]]
                beta[p] = ((n >> h) | 1) << h
            else:
                return False  # Exit traversal

    # Perform first traversal
    while traversal():
        pass

    # Begin second traversal
    p = nodes[0].child
    lam[0] = lam[n]
    pi[0] = beta[0] = alfa[0] = 0

    def compute_alfa(node):
        nonlocal p

        # s7: Compute alfa, top-down
        alfa[node] = alfa[nodes[node].parent] | (beta[node] & -beta[node])

        if nodes[node].child:
            compute_alfa(nodes[node].child)

        # s8: Continue traversal
        if nodes[node].sib:
            compute_alfa(nodes[node].sib)

    # Perform second traversal
    if p:
        compute_alfa(p)

    return pi, beta, alfa, tau, lam

def nca(x: int, y: int, beta: List[int], alfa: List[int], tau: List[int], lam: List[int], pi: List[int]) -> int:
    # Find common height
    if beta[x] <= beta[y]:
        h = lam[beta[y] & -beta[x]]
    else:
        h = lam[beta[x] & -beta[y]]

    # Find true height
    k = alfa[x] & alfa[y] & -(1 << h)
    h = lam[k & -k]

    # Find beta[z]
    j = ((beta[x] >> h) | 1) << h

    # Find x' and y'
    if j != beta[x]:
        l = lam[alfa[x] & ((1 << h) - 1)]
        x = tau[((beta[x] >> l) | 1) << l]

    if j != beta[y]:
        l = lam[alfa[y] & ((1 << h) - 1)]
        y = tau[((beta[y] >> l) | 1) << l]

    # Find z
    z = x if pi[x] <= pi[y] else y
    return z

def solve_test_case(n: int, values: List[int], queries: List[Tuple[int, int]]) -> List[int]:
    results = []

    A = [sys.maxsize]  # A[0]
    R = [0] * (n + 2)
    B = [0] * (n + 2)

    N = 1
    count = 0
    oldx = None

    for i in range(1, n + 1):
        x = values[i - 1]

        if i > 1 and x != oldx:
            A.append(count)
            R[N] = i
            N += 1
            count = 0

        B[i] = N
        count += 1
        oldx = x

    A.append(count)
    R[N] = n + 1

    pi, beta, alfa, tau, lam = process(N, A)

    for i, j in queries:
        x, y = B[i], B[j]

        if x == y:
            z = j - i + 1
        else:
            if x + 1 != y:
                z = A[nca(x + 1, y - 1, beta, alfa, tau, lam, pi)]
            else:
                z = 0

            z = max(z, max(R[x] - i, A[y] - R[y] + j + 1))

        results.append(z)

    return results

def main():
    # Hard-coded test data
    test_cases = [
        {
            "n": 10,
            "values": [-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
            "queries": [(2, 3), (1, 10), (5, 10)],
            "expected": [1, 4, 3]
        }
    ]

    for idx, test in enumerate(test_cases):
        n = test["n"]
        values = test["values"]
        queries = test["queries"]
        expected = test["expected"]

        print(f"Test Case {idx + 1}:")
        print(f"Size: {n}, Queries: {len(queries)}")
        print(f"Values: {' '.join(map(str, values))}")

        results = solve_test_case(n, values, queries)

        print("Queries and Results:")
        for q_idx, ((i, j), result, exp) in enumerate(zip(queries, results, expected)):
            print(f"Query: {i} {j}")
            print(f"Result: {result} (Expected: {exp})")
            if result != exp:
                print("  WARNING: Result doesn't match expected output")

        print()

if __name__ == "__main__":
    main()
