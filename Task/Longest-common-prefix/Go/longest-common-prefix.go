package main

import "fmt"

// lcp finds the longest common prefix of the input strings.
// It compares by bytes instead of runes (Unicode code points).
// It's up to the caller to do Unicode normalization if desired
// (e.g. see golang.org/x/text/unicode/norm).
func lcp(l []string) string {
	// Special cases first
	switch len(l) {
	case 0:
		return ""
	case 1:
		return l[0]
	}
	// LCP of min and max (lexigraphically)
	// is the LCP of the whole set.
	min, max := l[0], l[0]
	for _, s := range l[1:] {
		switch {
		case s < min:
			min = s
		case s > max:
			max = s
		}
	}
	for i := 0; i < len(min) && i < len(max); i++ {
		if min[i] != max[i] {
			return min[:i]
		}
	}
	// In the case where lengths are not equal but all bytes
	// are equal, min is the answer ("foo" < "foobar").
	return min
}

// Normally something like this would be a TestLCP function in *_test.go
// and use the testing package to report failures.
func main() {
	for _, l := range [][]string{
		{"interspecies", "interstellar", "interstate"},
		{"throne", "throne"},
		{"throne", "dungeon"},
		{"throne", "", "throne"},
		{"cheese"},
		{""},
		nil,
		{"prefix", "suffix"},
		{"foo", "foobar"},
	} {
		fmt.Printf("lcp(%q) = %q\n", l, lcp(l))
	}
}
