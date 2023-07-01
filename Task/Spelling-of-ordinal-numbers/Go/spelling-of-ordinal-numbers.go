import (
	"fmt"
	"strings"
)

func main() {
	for _, n := range []int64{
		1, 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003,
	} {
		fmt.Println(sayOrdinal(n))
	}
}

var irregularOrdinals = map[string]string{
	"one":    "first",
	"two":    "second",
	"three":  "third",
	"five":   "fifth",
	"eight":  "eighth",
	"nine":   "ninth",
	"twelve": "twelfth",
}

func sayOrdinal(n int64) string {
	s := say(n)
	i := strings.LastIndexAny(s, " -")
	i++
	// Now s[:i] is everything upto and including the space or hyphen
	// and s[i:] is the last word; we modify s[i:] as required.
	// Since LastIndex returns -1 if there was no space/hyphen,
	// `i` will be zero and this will still be fine.
	if x, ok := irregularOrdinals[s[i:]]; ok {
		s = s[:i] + x
	} else if s[len(s)-1] == 'y' {
		s = s[:i] + s[i:len(s)-1] + "ieth"
	} else {
		s = s[:i] + s[i:] + "th"
	}
	return s
}

// Below is a copy of https://rosettacode.org/wiki/Number_names#Go

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
