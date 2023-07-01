package main

import "fmt"

var a1 = []string{"a", "b", "c"}
var a2 = []byte{'A', 'B', 'C'}
var a3 = []int{1, 2, 3}

func main() {
	for i := range a1 {
		fmt.Printf("%v%c%v\n", a1[i], a2[i], a3[i])
	}
}
