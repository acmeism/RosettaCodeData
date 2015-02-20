package main

import "fmt"

func happy(n int) bool {
	m := make(map[int]bool)
	for n > 1 {
		m[n] = true
		var x int
		for x, n = n, 0; x > 0; x /= 10 {
			d := x % 10
			n += d * d
		}
		if m[n] {
			return false
		}
	}
	return true
}

func main() {
	for found, n := 0, 1; found < 8; n++ {
		if happy(n) {
			fmt.Print(n, " ")
			found++
		}
	}
	fmt.Println()
}
