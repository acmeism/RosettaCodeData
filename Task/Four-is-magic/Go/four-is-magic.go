package main

import (
	"fmt"
	"math"
	"strings"
)

func main() {
	for _, n := range [...]int64{
		0, 4, 6, 11, 13, 75, 100, 337, -164,
		math.MaxInt64,
	} {
		fmt.Println(fourIsMagic(n))
	}
}

func fourIsMagic(n int64) string {
	s := say(n)
	s = strings.ToUpper(s[:1]) + s[1:]
	t := s
	for n != 4 {
		n = int64(len(s))
		s = say(n)
		t += " is " + s + ", " + s
	}
	t += " is magic."
	return t
}

// Following is from https://rosettacode.org/wiki/Number_names#Go

var small = [...]string{"zero", "one", "two", "three", "four", "five", "six",
	"seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen",
	"fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
var tens = [...]string{"", "", "twenty", "thirty", "forty",
	"fifty", "sixty", "seventy", "eighty", "ninety"}
var illions = [...]string{"", " thousand", " million", " billion",
	" trillion", " quadrillion", " quintillion"}

func say(n int64) string {
	var t string
	if n < 0 {
		t = "negative "
		// Note, for math.MinInt64 this leaves n negative.
		n = -n
	}
	switch {
	case n < 20:
		t += small[n]
	case n < 100:
		t += tens[n/10]
		s := n % 10
		if s > 0 {
			t += "-" + small[s]
		}
	case n < 1000:
		t += small[n/100] + " hundred"
		s := n % 100
		if s > 0 {
			t += " " + say(s)
		}
	default:
		// work right-to-left
		sx := ""
		for i := 0; n > 0; i++ {
			p := n % 1000
			n /= 1000
			if p > 0 {
				ix := say(p) + illions[i]
				if sx != "" {
					ix += " " + sx
				}
				sx = ix
			}
		}
		t += sx
	}
	return t
}
