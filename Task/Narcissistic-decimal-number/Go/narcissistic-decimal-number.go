package main

import "fmt"

func narc(n int) []int {
	power := [...]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
	limit := 10
	result := make([]int, 0, n)
	for x := 0; len(result) < n; x++ {
		if x >= limit {
			for i := range power {
				power[i] *= i // i^m
			}
			limit *= 10
		}
		sum := 0
		for xx := x; xx > 0; xx /= 10 {
			sum += power[xx%10]
		}
		if sum == x {
			result = append(result, x)
		}
	}
	return result
}

func main() {
	fmt.Println(narc(25))
}
