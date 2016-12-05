package main

import "fmt"

func A(k int, x1, x2, x3, x4, x5 func() int) (a int) {
	var B func() int
	B = func() (b int) {
		k--
		a = A(k, B, x1, x2, x3, x4)
		b = a
		return
	}
	if k <= 0 {
		a = x4() + x5()
	} else {
		_ = B()
	}
	return
}

func main() {
	K := func(x int) func() int { return func() int { return x } }
	fmt.Println(A(10, K(1), K(-1), K(-1), K(1), K(0)))
}
