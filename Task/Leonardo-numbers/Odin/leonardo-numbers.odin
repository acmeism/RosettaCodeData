package main
/* imports */
import "core:fmt"
/* main */
main :: proc() {
	fmt.println("\nThe first 25 Leonardo numbers with L[0] = 1, L[1] = 1 and add number = 1 are:")
	result := leonardo(25, 1, 1, 1)
	fmt.println(result)
	delete(result)
	fmt.println("\nThe first 25 Leonardo numbers with L[0] = 0, L[1] = 1 and add number = 0 are:")
	result = leonardo(25, 0, 1, 0)
	fmt.println(result)
	delete(result)
}
/* definitions */
leonardo :: proc(n, l0, l1, add: int) -> []int {
	leo := make([]int, n)
	leo[0] = l0
	leo[1] = l1
	for i in 2 ..< n {
		leo[i] = leo[i - 1] + leo[i - 2] + add
	}
	return leo
}
