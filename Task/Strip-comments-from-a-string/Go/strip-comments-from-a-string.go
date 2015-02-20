package main

import (
	"fmt"
	"strings"
	"unicode"
)

const commentChars = "#;"

func stripComment(source string) string {
	if cut := strings.IndexAny(source, commentChars); cut >= 0 {
		return strings.TrimRightFunc(source[:cut], unicode.IsSpace)
	}
	return source
}

func main() {
	for _, s := range []string{
		"apples, pears # and bananas",
		"apples, pears ; and bananas",
		"no bananas",
	} {
		fmt.Printf("source:   %q\n", s)
		fmt.Printf("stripped: %q\n", stripComment(s))
	}
}
