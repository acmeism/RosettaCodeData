package main

import (
	"fmt"
	"math"
)

type Node struct {
	Child  int
	Sib    int
	Parent int
}

type Result struct {
	Pi   []int
	Beta []int
	Alfa []int
	Tau  []int
	Lam  []int
}

// Process function replicates the main logic
func process(N int, A []int) Result {
	pi := make([]int, N+1)
	beta := make([]int, N+1)
	alfa := make([]int, N+1)
	tau := make([]int, N+1)
	lam := make([]int, N+1)
	nodes := make([]Node, N+1)

	// Make triply linked tree
	t := 0
	for v := N; v > 0; v-- {
		u := 0
		for A[v] > A[t] || (A[v] == A[t] && v > t) {
			u = t
			t = nodes[t].Parent
		}

		if u != 0 {
			nodes[v].Sib = nodes[u].Sib
			nodes[u].Sib = 0
			nodes[u].Parent = v
			nodes[v].Child = u
		} else {
			nodes[v].Sib = nodes[t].Child
		}

		nodes[t].Child = v
		nodes[v].Parent = t
		t = v
	}

	// First traversal
	p := nodes[0].Child
	n := 0
	lam[0] = -1

	for traversal(nodes, p, n, pi, beta, tau, lam) {
		n = getN()
		p = getP()
	}

	// Second traversal
	p = nodes[0].Child
	lam[0] = lam[n]
	pi[0] = 0
	beta[0] = 0
	alfa[0] = 0

	if p != 0 {
		computeAlfa(nodes, p, alfa, beta)
	}

	return Result{Pi: pi, Beta: beta, Alfa: alfa, Tau: tau, Lam: lam}
}

// Static variables to simulate nonlocal variables
var p, n int

func getP() int {
	return p
}

func getN() int {
	return n
}

func traversal(nodes []Node, initialP, initialN int, pi, beta, tau, lam []int) bool {
	p = initialP
	n = initialN

	for {
		n++
		pi[p] = n
		tau[n] = 0
		lam[n] = 1 + lam[n>>1]

		if nodes[p].Child != 0 {
			p = nodes[p].Child
			continue
		}

		beta[p] = n
		break
	}

	for {
		tau[beta[p]] = nodes[p].Parent

		if nodes[p].Sib != 0 {
			p = nodes[p].Sib
			return true
		}

		p = nodes[p].Parent

		if p != 0 {
			h := lam[n&-pi[p]]
			beta[p] = ((n >> h) | 1) << h
		} else {
			return false
		}
	}
}

func computeAlfa(nodes []Node, node int, alfa, beta []int) {
	alfa[node] = alfa[nodes[node].Parent] | (beta[node] & -beta[node])

	if nodes[node].Child != 0 {
		computeAlfa(nodes, nodes[node].Child, alfa, beta)
	}

	if nodes[node].Sib != 0 {
		computeAlfa(nodes, nodes[node].Sib, alfa, beta)
	}
}

func nca(x, y int, beta, alfa, tau, lam, pi []int) int {
	var h int
	if beta[x] <= beta[y] {
		h = lam[beta[y]&-beta[x]]
	} else {
		h = lam[beta[x]&-beta[y]]
	}

	k := alfa[x] & alfa[y] & -(1 << h)
	h = lam[k&-k]

	j := ((beta[x] >> h) | 1) << h

	if j != beta[x] {
		l := lam[alfa[x]&((1<<h)-1)]
		x = tau[((beta[x]>>l)|1)<<l]
	}

	if j != beta[y] {
		l := lam[alfa[y]&((1<<h)-1)]
		y = tau[((beta[y]>>l)|1)<<l]
	}

	if pi[x] <= pi[y] {
		return x
	}
	return y
}

func solveTestCase(n int, values []int, queries [][]int) []int {
	results := []int{}

	A := make([]int, n+2)
	A[0] = math.MaxInt32
	R := make([]int, n+2)
	B := make([]int, n+2)

	N := 1
	count := 0
	var oldx *int

	for i := 1; i <= n; i++ {
		x := values[i-1]

		if i > 1 && (oldx == nil || x != *oldx) {
			A[N] = count
			R[N] = i
			N++
			count = 0
		}

		B[i] = N
		count++
		oldx = &x
	}

	A[N] = count
	R[N] = n + 1

	result := process(N, A)
	pi := result.Pi
	beta := result.Beta
	alfa := result.Alfa
	tau := result.Tau
	lam := result.Lam

	for _, query := range queries {
		i, j := query[0], query[1]
		x, y := B[i], B[j]

		var z int
		if x == y {
			z = j - i + 1
		} else {
			if x+1 != y {
				z = A[nca(x+1, y-1, beta, alfa, tau, lam, pi)]
			} else {
				z = 0
			}

			z = max(z, max(R[x]-i, A[y]-R[y]+j+1))
		}

		results = append(results, z)
	}

	return results
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}

func main() {
	testCases := []struct {
		n        int
		values   []int
		queries  [][]int
		expected []int
	}{
		{
			n:      10,
			values: []int{-1, -1, 1, 1, 1, 1, 3, 10, 10, 10},
			queries: [][]int{
				{2, 3}, {1, 10}, {5, 10},
			},
			expected: []int{1, 4, 3},
		},
	}

	for idx, testCase := range testCases {
		fmt.Printf("Test Case %d:\n", idx+1)
		results := solveTestCase(testCase.n, testCase.values, testCase.queries)
		fmt.Println("Results:", results)
	}
}
