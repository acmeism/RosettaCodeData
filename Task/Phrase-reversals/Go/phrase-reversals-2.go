package main

import (
	"fmt"
	"regexp"
	"sort"
	"strings"
)

const phrase = "rosetta code phrase reversal"

type reversible interface {
	Len() int
	Swap(i, j int)
}

func reverse(p reversible) {
	mid := p.Len() / 2
	last := p.Len() - 1
	for i := 0; i < mid; i++ {
		p.Swap(i, last-i)
	}
}

type runeSlice []rune

func (p runeSlice) Len() int      { return len(p) }
func (p runeSlice) Swap(i, j int) { p[i], p[j] = p[j], p[i] }

func reverseString(s string) string {
	r := runeSlice(s)
	reverse(r)
	return string(r)
}

var rx = regexp.MustCompile(`\S*`)

func reverseWords(s string) string {
	return rx.ReplaceAllStringFunc(s, func(m string) string {
		return reverseString(m)
	})
}

func reverseWordOrder(s string) string {
	l := sort.StringSlice(strings.Fields(s))
	reverse(l)
	return strings.Join(l, " ")
}

func main() {
	fmt.Println("Reversed:           ", reverseString(phrase))
	fmt.Println("Words reversed:     ", reverseWords(phrase))
	fmt.Println("Word order reversed:", reverseWordOrder(phrase))
}
