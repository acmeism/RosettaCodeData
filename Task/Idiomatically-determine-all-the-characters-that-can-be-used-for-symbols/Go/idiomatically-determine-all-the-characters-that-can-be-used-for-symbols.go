package main

import (
	"fmt"
	"go/ast"
	"go/parser"
	"strings"
	"unicode"
)

func isValidIdentifier(identifier string) bool {
	node, err := parser.ParseExpr(identifier)
	if err != nil {
		return false
	}
	ident, ok := node.(*ast.Ident)
	return ok && ident.Name == identifier
}

type runeRanges struct {
	ranges   []string
	hasStart bool
	start    rune
	end      rune
}

func (r *runeRanges) add(cp rune) {
	if !r.hasStart {
		r.hasStart = true
		r.start = cp
		r.end = cp
		return
	}

	if cp == r.end+1 {
		r.end = cp
		return
	}

	r.writeTo(&r.ranges)

	r.start = cp
	r.end = cp
}

func (r *runeRanges) writeTo(ranges *[]string) {
	if r.hasStart {
		if r.start == r.end {
			*ranges = append(*ranges, fmt.Sprintf("%U", r.end))
		} else {
			*ranges = append(*ranges, fmt.Sprintf("%U-%U", r.start, r.end))
		}
	}
}

func (r *runeRanges) String() string {
	ranges := r.ranges
	r.writeTo(&ranges)
	return strings.Join(ranges, ", ")
}

func main() {
	var validFirst runeRanges
	var validFollow runeRanges
	var validOnlyFollow runeRanges

	for r := rune(0); r <= unicode.MaxRune; r++ {
		first := isValidIdentifier(string([]rune{r}))
		follow := isValidIdentifier(string([]rune{'_', r}))
		if first {
			validFirst.add(r)
		}
		if follow {
			validFollow.add(r)
		}
		if follow && !first {
			validOnlyFollow.add(r)
		}
	}

	_, _ = fmt.Println("Valid first:", validFirst.String())
	_, _ = fmt.Println("Valid follow:", validFollow.String())
	_, _ = fmt.Println("Only follow:", validOnlyFollow.String())
}
