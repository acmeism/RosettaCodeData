package main

import "fmt"

func main() {
	// creature string
	var creature string = "shark"
	// point to creature
	var pointer *string = &creature
	// creature string
	fmt.Println("creature =", creature) // creature = shark
	// creature location in memory
	fmt.Println("pointer =", pointer) // pointer = 0xc000010210
	// creature through the pointer
	fmt.Println("*pointer =", *pointer) // *pointer = shark
	// set creature through the pointer
	*pointer = "jellyfish"
	// creature through the pointer
	fmt.Println("*pointer =", *pointer) // *pointer = jellyfish
	// creature string
	fmt.Println("creature =", creature) // creature = jellyfish
}
