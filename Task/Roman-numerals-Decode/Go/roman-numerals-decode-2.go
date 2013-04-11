package main

import (
	"fmt"
	"strings"
)

var m = map[string]int{
	"I": 1,
	"V": 5,
	"X": 10,
	"L": 50,
	"C": 100,
	"D": 500,
	"M": 1000,
}

// function, per task description
func from_roman(roman string) (arabic int) {
	last_digit := 1000
	for _, r := range strings.Split(roman, "") {
		digit := m[r]
		if last_digit < digit {
			arabic -= 2 * last_digit
		}
		last_digit = digit
		arabic += digit
	}

	return arabic
}

func main() {
	// parse three numbers mentioned in task description
	for _, roman_digit := range []string{"MCMXC", "MMVIII", "MDCLXVI"} {
		fmt.Printf("%-10s == %d\n", roman_digit, from_roman(roman_digit))
	}
}
