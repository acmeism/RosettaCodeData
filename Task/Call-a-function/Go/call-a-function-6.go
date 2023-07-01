package main

import "fmt"

func bar(a, b, c int) {
	fmt.Printf("%d, %d, %d", a, b, c)
}

func main() {
	args := make(map[string]int)
	args["a"] = 3
	args["b"] = 2
	args["c"] = 1
	bar(args["a"], args["b"], args["c"]) // prt 3, 2, 1
}
