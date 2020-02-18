package main

import "fmt"

// int parameter, so arguments will be passed to it by value.
func zeroval(ival int) {
	ival = 0
}
// has an *int parameter, meaning that it takes an int pointer.
func zeroptr(iptr *int) {
	*iptr = 0
}
func main() {
	i := 1
	fmt.Println("initial:", i) // prt initial: 1
	zeroval(i)
	fmt.Println("zeroval:", i) // prt zeroval: 1
	zeroptr(&i)
	fmt.Println("zeroptr:", i)  // prt zeroptr: 0
	fmt.Println("pointer:", &i) // prt pointer: 0xc0000140b8
}
