package cf

import (
	"fmt"
	"strings"
)

// ContinuedFraction is a regular continued fraction.
type ContinuedFraction func() NextFn

// NextFn is a function/closure that can return
// a posibly infinite sequence of values.
type NextFn func() (term int64, ok bool)

// String implements fmt.Stringer.
// It formats a maximum of 20 values, ending the
// sequence with ", ..." if the sequence is longer.
func (cf ContinuedFraction) String() string {
	var buf strings.Builder
	buf.WriteByte('[')
	sep := "; "
	const maxTerms = 20
	next := cf()
	for n := 0; ; n++ {
		t, ok := next()
		if !ok {
			break
		}
		if n > 0 {
			buf.WriteString(sep)
			sep = ", "
		}
		if n >= maxTerms {
			buf.WriteString("...")
			break
		}
		fmt.Fprint(&buf, t)
	}
	buf.WriteByte(']')
	return buf.String()
}

// Sqrt2 is the continued fraction for √2, [1; 2, 2, 2, ...].
func Sqrt2() NextFn {
	first := true
	return func() (int64, bool) {
		if first {
			first = false
			return 1, true
		}
		return 2, true
	}
}

// Phi is the continued fraction for ϕ, [1; 1, 1, 1, ...].
func Phi() NextFn {
	return func() (int64, bool) { return 1, true }
}

// E is the continued fraction for e,
// [2; 1, 2, 1, 1, 4, 1, 1, 6, 1, 1, 8, 1, 1, 10, 1, 1, 12, ...].
func E() NextFn {
	var i int
	return func() (int64, bool) {
		i++
		switch {
		case i == 1:
			return 2, true
		case i%3 == 0:
			return int64(i/3) * 2, true
		default:
			return 1, true
		}
	}
}
