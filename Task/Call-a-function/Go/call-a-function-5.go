package main

import "fmt"

type Params struct {
	a, b, c int
}
func doIt(p Params) int {
	return p.a + p.b + p.c
}

func main() {
	fmt.Println(doIt(Params{a: 1, c: 9})) // prt 10
}
