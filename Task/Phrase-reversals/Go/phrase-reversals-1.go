package main

import (
	"fmt"
	"strings"
)

const phrase = "rosetta code phrase reversal"

func revStr(s string) string {
	rs := make([]rune, len(s))
	i := len(s)
	for _, r := range s {
		i--
		rs[i] = r
	}
	return string(rs[i:])
}

func main() {
	fmt.Println("Reversed:           ", revStr(phrase))

	ws := strings.Fields(phrase)
	for i, w := range ws {
		ws[i] = revStr(w)
	}
	fmt.Println("Words reversed:     ", strings.Join(ws, " "))

	ws = strings.Fields(phrase)
	last := len(ws) - 1
	for i, w := range ws[:len(ws)/2] {
		ws[i], ws[last-i] = ws[last-i], w
	}
	fmt.Println("Word order reversed:", strings.Join(ws, " "))
}
