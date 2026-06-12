package main

import (
	"fmt"
	"math"
)

func generate(n int) [][]int {
	if n == 1 {
		return [][]int{{1}}
	}

	if n == 2 {
		return [][]int{{1}, {1, 2}}
	}

	res := make([][]int, n)
	res[0] = []int{1}
	res[1] = []int{1, 2}

	for i := 1; i < n-1; i++ {
		items := make([]int, i+2)
		items[0] = 1

		for j := 0; j < len(res[i])-1; j++ {
			items[j+1] = res[i][j] + res[i][j+1]
		}
		items[i+1] = int(math.Pow(2, float64(i+1)))
		res[i+1] = items
	}

	return res
}

func main() {
	for _, row := range generate(15) {
		fmt.Println(row)
	}
}
