package main

import (
	"fmt"
)

func test(s string) {
	if len(s) == 0 {
		fmt.Println("empty")
	} else {
		fmt.Println("not empty")
	}
}

func main() {
	// assign an empty string to a variable.
	str1 := ""
	str2 := " "
	// check if a string is empty.
	test(str1) // prt empty
	// check that a string is not empty.
	test(str2) // prt not empty
}
