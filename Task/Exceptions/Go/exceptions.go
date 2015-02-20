package main

import "fmt"

func foo() int {
	fmt.Println("let's foo...")
	defer func() {
		if e := recover(); e != nil {
			fmt.Println("Recovered from", e)
		}
	}()
	var a []int
	a[12] = 0
	fmt.Println("there's no point in going on.")
	panic("never reached")
	panic(fmt.Scan) // Can use any value, here a function!
}

func main() {
	foo()
	fmt.Println("glad that's over.")
}
