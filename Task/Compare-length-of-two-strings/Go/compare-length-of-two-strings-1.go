package main

import (
	"fmt"
	"os"
	"sort"
)

func main() {
	// If no command-line arguments are specified when running the program, use example data
	if len(os.Args) == 1 {
		compareStrings("abcd", "123456789", "abcdef", "1234567")
	} else {
		// First argument, os.Args[0], is program name. Command-line arguments start from 1
		strings := os.Args[1:]
		compareStrings(strings...)
	}
}

// Variadic function that takes any number of string arguments for comparison
func compareStrings(strings ...string) {
	// "strings" slice is sorted in place
	// sort.SliceStable keeps strings in their original order when elements are of equal length (unlike sort.Slice)
	sort.SliceStable(strings, func(i, j int) bool {
		return len(strings[i]) > len(strings[j])
	})

	for _, s := range strings {
		fmt.Printf("%d: %s\n", len(s), s)
	}
}
