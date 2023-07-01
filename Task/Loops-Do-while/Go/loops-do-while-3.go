package main

import "fmt"

func main() {
	// do-while loop 1
	n1 := 2
	for n1 < 6 {
		n1 *= 2
	}
	fmt.Println(n1) // prt 8
	// do-while loop 2
	n2 := 2
	for ok := true; ok; ok = n2%8 != 0 {
			n2 *= 2
	}
	fmt.Println(n2) // prt 8
	// do-while loop 3
	n3 := 2
	for {
		n3 *= 2
		if n3 >= 6 {
			break
		}
	}
	fmt.Println(n3) // prt 8
}
