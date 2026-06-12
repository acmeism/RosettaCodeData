package main

import (
	"fmt"
	"math"
)

type Faffian int

const (
	Pfaffian Faffian = iota
	Hfaffian
)

func (f Faffian) String() string {
	return [...]string{"Pfaffian", "Hfaffian"}[f]
}

type SignedPerm struct {
	permutation []int
	sign        int
}

func main() {
	matrices := [][][]int{
		{{0, 1}, {-1, 0}},
		{{0, 1, -1, 2}, {-1, 0, 3, -4}, {1, -3, 0, 5}, {-2, 4, -5, 0}},
		{{1, 2, 3, 4, 5, 6}, {2, 7, 8, 9, 10, 11}, {3, 8, 12, 13, 14, 15}, {4, 9, 13, 16, 17, 18}, {5, 10, 14, 17, 19, 20}, {6, 11, 15, 18, 20, 21}},
		{{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}, {-1, 0, 8, 7, 6, 5, 4, 3, 2, 1}, {-2, -8, 0, 1, 2, 3, 4, 5, 6, 7}, {-3, -7, -1, 0, 6, 5, 4, 3, 2, 1}, {-4, -6, -2, -6, 0, 1, 2, 3, 4, 5}, {-5, -5, -3, -5, -1, 0, 4, 3, 2, 1}, {-6, -4, -4, -4, -2, -4, 0, 1, 2, 3}, {-7, -3, -5, -3, -3, -3, -1, 0, 2, 1}, {-8, -2, -6, -2, -4, -2, -2, -2, 0, 1}, {-9, -1, -7, -1, -5, -1, -3, -1, -1, 0}},
	}

	for _, matrix := range matrices {
		printMatrix(matrix)
		for _, faffian := range []Faffian{Pfaffian, Hfaffian} {
			if result, ok := computeFaffian(matrix, faffian); ok {
				fmt.Printf("%s: %d\n", faffian, result)
			}
		}
		fmt.Println()
	}
}

func computeFaffian(matrix [][]int, faffian Faffian) (int64, bool) {
	if len(matrix)%2 != 0 {
		fmt.Printf("Matrix size must be even for %s\n", faffian)
		return 0, false
	}

	if !isAntisymmetric(matrix) {
		fmt.Printf("The %s does not support non-antisymmetric matrices\n", faffian)
		return 0, false
	}

	n := len(matrix) / 2
	sum := 0
	signedPerms := signedPermutations(2*n - 1)
	for _, signedPerm := range signedPerms {
		sigma := signedPerm.permutation
		sign := 1
		if faffian == Pfaffian {
			sign = signedPerm.sign
		}
		product := 1
		for i := 0; i < n; i++ {
			product *= matrix[sigma[2*i]][sigma[2*i+1]]
		}
		sum += sign * product
	}

	normalization := 1.0 / float64(factorial(n)) / math.Pow(2, float64(n))
	return int64(math.Round(float64(sum) * normalization)), true
}

func signedPermutations(n int) []SignedPerm {
	perms := make([]int, n+1)
	for i := range perms {
		perms[i] = i
	}
	signedPerms := []SignedPerm{{make([]int, n+1), 1}}
	copy(signedPerms[0].permutation, perms)
	sign := 1

	for k := 1; k < factorial(n+1); k++ {
		i := n - 1
		for perms[i] > perms[i+1] {
			i--
		}
		j := n
		for perms[j] < perms[i] {
			j--
		}
		swap(perms, i, j)
		sign = -sign
		i++
		j = n
		for i < j {
			swap(perms, i, j)
			sign = -sign
			i++
			j--
		}
		newPerm := make([]int, n+1)
		copy(newPerm, perms)
		signedPerms = append(signedPerms, SignedPerm{newPerm, sign})
	}
	return signedPerms
}

func isAntisymmetric(matrix [][]int) bool {
	for i := 0; i < len(matrix); i++ {
		if matrix[i][i] != 0 {
			return false
		}
		for j := i + 1; j < len(matrix); j++ {
			if matrix[i][j] != -matrix[j][i] {
				return false
			}
		}
	}
	return true
}

func factorial(n int) int {
	factorial := 1
	for i := 2; i <= n; i++ {
		factorial *= i
	}
	return factorial
}

func swap(list []int, i, j int) {
	list[i], list[j] = list[j], list[i]
}

func printMatrix(matrix [][]int) {
	for _, row := range matrix {
		fmt.Print("|")
		for i := 0; i < len(row)-1; i++ {
			fmt.Printf("%2d, ", row[i])
		}
		fmt.Printf("%2d|\n", row[len(row)-1])
	}
}

