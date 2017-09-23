package main

import "fmt"

func main() {
	var value int
	for {
		value++
		fmt.Println(value)
                if value%6 != 0 {
                        break
                }
	}
}
