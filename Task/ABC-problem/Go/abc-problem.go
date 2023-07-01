package main

import (
	"fmt"
	"strings"
)

func newSpeller(blocks string) func(string) bool {
	bl := strings.Fields(blocks)
	return func(word string) bool {
		return r(word, bl)
	}
}

func r(word string, bl []string) bool {
	if word == "" {
		return true
	}
	c := word[0] | 32
	for i, b := range bl {
		if c == b[0]|32 || c == b[1]|32 {
			bl[i], bl[0] = bl[0], b
			if r(word[1:], bl[1:]) == true {
				return true
			}
			bl[i], bl[0] = bl[0], bl[i]
		}
	}
	return false
}

func main() {
	sp := newSpeller(
		"BO XK DQ CP NA GT RE TG QD FS JW HU VI AN OB ER FS LY PC ZM")
	for _, word := range []string{
		"A", "BARK", "BOOK", "TREAT", "COMMON", "SQUAD", "CONFUSE"} {
		fmt.Println(word, sp(word))
	}
}
