package main

import (
	"fmt"
)

const numbers = 3

func main() {

	//using the provided data
	max := 20
	words := map[int]string{
		3: "Fizz",
		5: "Buzz",
		7: "Baxx",
	}
	keys := []int{3, 5, 7}
	divisible := false
	for i := 1; i <= max; i++ {
		for _, n := range keys {
			if i % n == 0 {
				fmt.Print(words[n])
				divisible = true
			}
		}
		if !divisible {
			fmt.Print(i)
		}
		fmt.Println()
		divisible = false
	}

}
