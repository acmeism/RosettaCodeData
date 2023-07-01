package main

import (
	"golang.org/x/text/transform"
	"golang.org/x/text/unicode/norm"
	"fmt"
	"strings"
)

// two byte-oriented functions identical except for operator comparing c to 127.
func stripCtlFromBytes(str string) string {
	b := make([]byte, len(str))
	var bl int
	for i := 0; i < len(str); i++ {
		c := str[i]
		if c >= 32 && c != 127 {
			b[bl] = c
			bl++
		}
	}
	return string(b[:bl])
}

func stripCtlAndExtFromBytes(str string) string {
	b := make([]byte, len(str))
	var bl int
	for i := 0; i < len(str); i++ {
		c := str[i]
		if c >= 32 && c < 127 {
			b[bl] = c
			bl++
		}
	}
	return string(b[:bl])
}

// two UTF-8 functions identical except for operator comparing c to 127
func stripCtlFromUTF8(str string) string {
	return strings.Map(func(r rune) rune {
		if r >= 32 && r != 127 {
			return r
		}
		return -1
	}, str)
}

func stripCtlAndExtFromUTF8(str string) string {
	return strings.Map(func(r rune) rune {
		if r >= 32 && r < 127 {
			return r
		}
		return -1
	}, str)
}

// Advanced Unicode normalization and filtering,
// see http://blog.golang.org/normalization and
// http://godoc.org/golang.org/x/text/unicode/norm for more
// details.
func stripCtlAndExtFromUnicode(str string) string {
	isOk := func(r rune) bool {
		return r < 32 || r >= 127
	}
	// The isOk filter is such that there is no need to chain to norm.NFC
	t := transform.Chain(norm.NFKD, transform.RemoveFunc(isOk))
	// This Transformer could also trivially be applied as an io.Reader
	// or io.Writer filter to automatically do such filtering when reading
	// or writing data anywhere.
	str, _, _ = transform.String(t, str)
	return str
}

const src = "déjà vu" + // precomposed unicode
	"\n\000\037 \041\176\177\200\377\n" + // various boundary cases
	"as⃝df̅" // unicode combining characters

func main() {
	fmt.Println("source text:")
	fmt.Println(src)
	fmt.Println("\nas bytes, stripped of control codes:")
	fmt.Println(stripCtlFromBytes(src))
	fmt.Println("\nas bytes, stripped of control codes and extended characters:")
	fmt.Println(stripCtlAndExtFromBytes(src))
	fmt.Println("\nas UTF-8, stripped of control codes:")
	fmt.Println(stripCtlFromUTF8(src))
	fmt.Println("\nas UTF-8, stripped of control codes and extended characters:")
	fmt.Println(stripCtlAndExtFromUTF8(src))
	fmt.Println("\nas decomposed and stripped Unicode:")
	fmt.Println(stripCtlAndExtFromUnicode(src))
}
