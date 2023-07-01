package main

import "fmt"

func main() {
	bottles := func(i int) string {
		switch i {
		case 0:
			return "No more bottles"
		case 1:
			return "1 bottle"
		default:
			return fmt.Sprintf("%d bottles", i)
		}
	}

	for i := 99; i > 0; i-- {
		fmt.Printf("%s of beer on the wall\n", bottles(i))
		fmt.Printf("%s of beer\n", bottles(i))
		fmt.Printf("Take one down, pass it around\n")
		fmt.Printf("%s of beer on the wall\n", bottles(i-1))
	}
}
