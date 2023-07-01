package main

import "fmt"

func main() {
	const (
		target  = 269696
		modulus = 1000000
	)
	for n := 1; ; n++ { // Repeat with n=1, n=2, n=3, ...
		square := n * n
		ending := square % modulus
		if ending == target {
			fmt.Println("The smallest number whose square ends with",
				target, "is", n,
			)
			return
		}
	}
}
