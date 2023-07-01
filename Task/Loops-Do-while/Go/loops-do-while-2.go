package main

import "fmt"

func main() {
	var value int
	for ok := true; ok; ok = value%6 != 0 {
		value++
		fmt.Println(value)
	}
}
