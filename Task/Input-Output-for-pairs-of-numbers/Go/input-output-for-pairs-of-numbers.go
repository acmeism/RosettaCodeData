package main

import (
	"fmt"
	"log"
)

func main() {
	var lines int
	n, err := fmt.Scanln(&lines)
	if n != 1 || err != nil {
		log.Fatal(err)
	}

	var a, b int
	for ; lines > 0; lines-- {
		n, err = fmt.Scanln(&a, &b)
		if n != 2 || err != nil {
			log.Fatal(err)
		}
		fmt.Println(a + b)
	}
}
