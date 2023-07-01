package main

import "fmt"

func main() {
	// defer run last
	defer fmt.Println("World")
	fmt.Println("Hello")
	// goto
	i := 0
Here:
	if i < 5 {
		fmt.Println(i)
		i++
		goto Here
	} else {
		fmt.Println("i is less than 5")
	}
	// break & continue
	number := 0
	for {
		number++
		if number > 3 {
			break
		}
		if number == 2 {
			continue
		}
		fmt.Printf("%v\n", number)
	}
}
// init
func init() {
	fmt.Println("run first")
}
