package main

import (
	"fmt"
	"log"
)

func main() {
	var n1, n2 int
	fmt.Print("enter number: ")
	if _, err := fmt.Scan(&n1); err != nil {
		log.Fatal(err)
	}
	fmt.Print("enter number: ")
	if _, err := fmt.Scan(&n2); err != nil {
		log.Fatal(err)
	}
	switch {
	case n1 < n2:
		fmt.Println(n1, "less than", n2)
	case n1 == n2:
		fmt.Println(n1, "equal to", n2)
	case n1 > n2:
		fmt.Println(n1, "greater than", n2)
	}
}
