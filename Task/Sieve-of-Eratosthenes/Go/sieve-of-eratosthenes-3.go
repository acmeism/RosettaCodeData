package main

import (
	"fmt"
)

func filter(n int, in chan int) chan int {
	out := make(chan int)
	go func() {
		for i := range in {
			if i%n != 0 {
				out <- i
			}
		}
		close(out)
	}()

	return out
}

func ints(max int) chan int {
	out := make(chan int)
	go func() {
		for i := 2; i <= max; i++ {
			out <- i
		}
		close(out)
	}()

	return out
}

func main() {
	ch := ints(201)
	for {
		i := <-ch
		if i == 0 {
			break
		}
		fmt.Println(i)
		ch = filter(i, ch)
	}
}
