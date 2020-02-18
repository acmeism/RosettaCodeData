package main

import (
	"fmt"
	"strconv"
)

func main() {
	n1 := uint64(727)
	fmt.Println(n1) // prt 727
	bin := fmt.Sprintf("%#b", n1)
	fmt.Println(bin) // prt 0b1011010111

	oct, _ := fmt.Printf("%#o", n1)
	fmt.Println(oct) // prt 013275

	hex := fmt.Sprintf("%#x", n1)
	fmt.Println(hex) // prt 0x2d7

	n2, _ := strconv.ParseUint(hex, 0, 64)
	fmt.Println(n2)       // prt 727
	fmt.Println(n1 == n2) // prt true
}
