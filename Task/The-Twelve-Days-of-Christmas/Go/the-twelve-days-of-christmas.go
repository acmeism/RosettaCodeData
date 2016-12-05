package main

import (
	"fmt"
	"strings"
)

func main() {
	numbers := []string{"first", "second", "third", "fourth", "fifth",
		"sixth", "seventh", "eighth", "ninth", "tenth",
		"eleventh", "twelfth"}

	gifts := []string{"And a partridge in a pear tree", "Two turtle doves",
		"Three French hens", "Four calling birds",
		"Five gold rings", "Six geese a-laying",
		"Seven swans a-swimming", "Eight maids a-miling",
		"Nine ladies dancing", "Ten lords a-leaping",
		"Eleven pipers piping", "Twelve drummers drumming"}

	day := func(n int) {
		fmt.Printf("On the %s day of Christams, my true love sent to me\n", numbers[n])
	}

	day(0)
	fmt.Println(strings.Replace(gifts[0], "And a", "A", 1))
	for d := 1; d < 12; d++ {
		fmt.Println()
		day(d)
		for g := d; g >= 0; g-- {
			fmt.Println(gifts[g])
		}
	}
}
