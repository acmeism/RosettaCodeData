package main

import (
	"errors"
	"fmt"
)

func fib(n int) (result int, err error) {
	var fib func(int) int // Must be declared first so it can be called in the closure
	fib = func(n int) int {
		if n < 2 {
			return n
		}
		return fib(n-1) + fib(n-2)
	}

	if n < 0 {
		err = errors.New("negative n is forbidden")
		return
	}

	result = fib(n)
	return
}

func main() {
	for i := -1; i <= 10; i++ {
		if result, err := fib(i); err != nil {
			fmt.Printf("fib(%d) returned error: %s\n", i, err)
		} else {
			fmt.Printf("fib(%d) = %d\n", i, result)
		}
	}
}
