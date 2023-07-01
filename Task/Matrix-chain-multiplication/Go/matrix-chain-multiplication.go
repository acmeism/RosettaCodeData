package main

import "fmt"

// PrintMatrixChainOrder prints the optimal order for chain
// multiplying matrices.
// Matrix A[i] has dimensions dims[i-1]×dims[i].
func PrintMatrixChainOrder(dims []int) {
	n := len(dims) - 1
	m, s := newSquareMatrices(n)

	// m[i,j] will be minimum number of scalar multiplactions
	// needed to compute the matrix A[i]A[i+1]…A[j] = A[i…j].
	// Note, m[i,i] = zero (no cost).
	// s[i,j] will be the index of the subsequence split that
	// achieved minimal cost.
	for lenMinusOne := 1; lenMinusOne < n; lenMinusOne++ {
		for i := 0; i < n-lenMinusOne; i++ {
			j := i + lenMinusOne
			m[i][j] = -1
			for k := i; k < j; k++ {
				cost := m[i][k] + m[k+1][j] + dims[i]*dims[k+1]*dims[j+1]
				if m[i][j] < 0 || cost < m[i][j] {
					m[i][j] = cost
					s[i][j] = k
				}
			}
		}
	}

	// Format and print result.
	const MatrixNames = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var subprint func(int, int)
	subprint = func(i, j int) {
		if i == j {
			return
		}
		k := s[i][j]
		subprint(i, k)
		subprint(k+1, j)
		fmt.Printf("%*s -> %s × %s%*scost=%d\n",
			n, MatrixNames[i:j+1],
			MatrixNames[i:k+1],
			MatrixNames[k+1:j+1],
			n+i-j, "", m[i][j],
		)
	}
	subprint(0, n-1)
}

func newSquareMatrices(n int) (m, s [][]int) {
	// Allocates two n×n matrices as slices of slices but
	// using only one [2n][]int and one [2n²]int backing array.
	m = make([][]int, 2*n)
	m, s = m[:n:n], m[n:]
	tmp := make([]int, 2*n*n)
	for i := range m {
		m[i], tmp = tmp[:n:n], tmp[n:]
	}
	for i := range s {
		s[i], tmp = tmp[:n:n], tmp[n:]
	}
	return m, s
}

func main() {
	cases := [...][]int{
		{1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2},
		{1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10},
	}
	for _, tc := range cases {
		fmt.Println("Dimensions:", tc)
		PrintMatrixChainOrder(tc)
		fmt.Println()
	}
}
