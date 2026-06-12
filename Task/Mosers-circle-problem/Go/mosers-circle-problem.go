package main

import (
	"fmt"
	"math"
)

func moser(n int) int {
	nf := float64(n)
	return int((math.Pow(nf, 4) - 6*math.Pow(nf, 3) + 23*math.Pow(nf, 2) - 18*nf + 24) / 24)
}

func binomial(n int, k int) int {
	result := 1
	if k < 0 || k > n {
		return 0
	}
	for i := 1; i <= k; i++ {
		result = result * (n - i + 1) / i
	}
	return result
}

func binomialTransform(seq []int, result []int, p int) {
	for n := range p {
		sum := 0
		for k := 0; k <= n; k++ {
			sum += binomial(n, k) * seq[k]
		}
		result[n] = sum
	}
}

func pascalsTriangle(tri []int, p int) {
	arr := make([][]int, p)

	for i := range p {
		arr[i] = make([]int, p)
	}

	for r := range p {
		arr[r][0] = 1
		for c := 1; c <= r; c++ {
			arr[r][c] = arr[r-1][c-1] + arr[r-1][c]
		}
	}

	for r := range p {
		tri[r] = 0

		for c := range 5 {
			tri[r] += arr[r][c]
		}
	}

}

func main() {
	p := 20

	fmt.Println("The first 20 values of Moser's circle problem calculated in different ways:")
	fmt.Println("\nDirect calculation of a 4th order equation:")

	for i := 1; i <= p; i++ {
		fmt.Print(moser(i), " ")
	}

	fmt.Println("\n\nUsing binomial sums:")

	for i := 1; i <= p; i++ {
		fmt.Print(binomial(i, 4)+binomial(i, 2)+1, " ")
	}

	fmt.Println("\n\nUsing a binomial transform:")

	seq := make([]int, p)
	bt := make([]int, p)

	for i := range p {
		if i < 5 {
			seq[i] = 1
		}
	}

	binomialTransform(seq, bt, p)

	for i := range p {
		fmt.Print(bt[i], " ")
	}

	fmt.Println("\n\nPartial sums of Pascals triangle:")
	tri := make([]int, p)

	pascalsTriangle(tri, p)

	for i := range p {
		fmt.Print(tri[i], " ")
	}
	fmt.Println()
}
