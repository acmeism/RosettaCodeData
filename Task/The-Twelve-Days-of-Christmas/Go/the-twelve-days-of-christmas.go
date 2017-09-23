package main

import (
	"fmt"
)

func main() {
	days := []string{"first", "second", "third", "fourth", "fifth", "sixth",
		"seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth"}

	gifts := []string{"A Patridge in a Pear Tree", "Two Turtle Doves and", "Three French Hens",
		"Four Calling Birds", "Five Golden Rings", "Six Geese a Laying",
		"Seven Swans a Swimming", "Eight Maids a Milking", "Nine Ladies Dancing",
		"Ten Lords a Leaping", "Eleven Pipers Piping", "Twelve Drummers Drumming"}

	for i := 0; i < 12; i++ {
		fmt.Printf("On the %s day of Christmas,\n", days[i])
		fmt.Println("My true love gave to me:")

		for j := i; j >= 0; j-- {
			fmt.Println(gifts[j])
		}
		fmt.Println()
	}
}
