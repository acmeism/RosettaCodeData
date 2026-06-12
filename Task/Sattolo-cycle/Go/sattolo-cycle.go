package main

import (
	"math/rand"
	"fmt"
)

func main() {
	list := []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	for i := 1; i <= 10; i++ {
		sattoloCycle(list)
		fmt.Println(list)
	}
}

func sattoloCycle(list []int) {
	for x := len(list) -1; x > 0; x-- {
		j := rand.Intn(x)
		list[x], list[j] = list[j], list[x]
	}
}
