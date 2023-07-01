package main

import (
	"errors"
	"fmt"
)

func TokenizeString(s string, sep, escape rune) (tokens []string, err error) {
	var runes []rune
	inEscape := false
	for _, r := range s {
		switch {
		case inEscape:
			inEscape = false
			fallthrough
		default:
			runes = append(runes, r)
		case r == escape:
			inEscape = true
		case r == sep:
			tokens = append(tokens, string(runes))
			runes = runes[:0]
		}
	}
	tokens = append(tokens, string(runes))
	if inEscape {
		err = errors.New("invalid terminal escape")
	}
	return tokens, err
}

func main() {
	const sample = "one^|uno||three^^^^|four^^^|^cuatro|"
	const separator = '|'
	const escape = '^'

	fmt.Printf("Input:   %q\n", sample)
	tokens, err := TokenizeString(sample, separator, escape)
	if err != nil {
		fmt.Println("error:", err)
	} else {
		fmt.Printf("Tokens: %q\n", tokens)
	}
}
