package main

import (
	"fmt"
)

func main() {
	n := []int{1, 2, 3, 4, 5}

	fmt.Println(reduce(add, n))
	fmt.Println(reduce(sub, n))
	fmt.Println(reduce(mul, n))
}

func add(a int, b int) int { return a + b }
func sub(a int, b int) int { return a - b }
func mul(a int, b int) int { return a * b }

func reduce(rf func(int, int) int, m []int) int {
	r := m[0]
	for _, v := range m[1:] {
		r = rf(r, v)
	}
	return r
}
