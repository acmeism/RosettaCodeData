package main

import "fmt"

func mkAdd(a int) func(int) int {
	return func(b int) int {
		return a + b
	}
}
func sum(x, y int) int {
	return x + y
}

func partialSum(x int) func(int) int {
	return func(y int) int {
		return sum(x, y)
	}
}
func main() {
	// Is partial application possible and how
	add2 := mkAdd(2)
	add3 := mkAdd(3)
	fmt.Println(add2(5), add3(6)) // prt 7 9
	// Currying functions in go
	partial := partialSum(13)
	fmt.Println(partial(5)) //prt 18
}
