package main

import (
	"fmt"
	"github.com/jbarham/primegen.go"
)

func main() {
	p := primegen.New()

	fmt.Print("First twenty: ")
	for i := 0; i < 20; i++ {
		fmt.Print(p.Next(), " ")
	}
	fmt.Print("\nBetween 100 and 150: ")
	p.SkipTo(100)
	for n := p.Next(); n < 150; n = p.Next() {
		fmt.Print(n, " ")
	}
	p.SkipTo(7700)
	fmt.Println("\nNumber beween 7,700 and 8,000:", p.Count(8000))
	p.Reset()
	for i := 1; i < 1e4; i++ {
		p.Next()
	}
	fmt.Println("10,000th prime:", p.Next())
}
