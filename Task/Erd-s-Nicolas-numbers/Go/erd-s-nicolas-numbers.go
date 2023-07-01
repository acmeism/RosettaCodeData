package main

import "fmt"

func main() {
	const maxNumber = 100000000
	dsum := make([]int, maxNumber+1)
	dcount := make([]int, maxNumber+1)
	for i := 0; i <= maxNumber; i++ {
		dsum[i] = 1
		dcount[i] = 1
	}
	for i := 2; i <= maxNumber; i++ {
		for j := i + i; j <= maxNumber; j += i {
			if dsum[j] == j {
				fmt.Printf("%8d equals the sum of its first %d divisors\n", j, dcount[j])
			}
			dsum[j] += i
			dcount[j]++
		}
	}
}
