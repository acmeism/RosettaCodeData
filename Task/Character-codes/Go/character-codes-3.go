package main

import "fmt"

func main() {
	// yes, there is more concise syntax, but this makes
	// the data types very clear.
	var b byte = 'a'
	var r rune = 'π'
	var s string = "aπ"

	fmt.Println(b, r, s)
	fmt.Println("string cast to []rune:", []rune(s))
	// A range loop over a string gives runes, not bytes
	fmt.Print("    string range loop: ")
	for _, c := range s {
		fmt.Print(c, " ") // c is type rune
	}
	// We can also print the bytes of a string without an explicit loop
	fmt.Printf("\n         string bytes: % #x\n", s)
}
