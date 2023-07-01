package expand

import (
	"fmt"
	"reflect"
	"testing"
)

// These could be in expand.go but for now they're only used for debugging.
func (t Text) String() string          { return fmt.Sprintf("%#q", string(t)) }
func (alt Alternation) String() string { return fmt.Sprintf("ALT:%v", []Expander(alt)) }

// From http://rosettacode.org/wiki/Brace_expansion
var testCases = []struct {
	input    string
	expected []string
}{
	{"", []string{""}},
	{"a{2,1}b{X,Y,X}c", []string{
		"a2bXc",
		"a2bYc",
		"a2bXc",
		"a1bXc",
		"a1bYc",
		"a1bXc"}},
	{`a\\{\\\{b,c\,d}`, []string{
		`a\\\\\{b`,
		`a\\c\,d`}},
	{"{a,b{c{,{d}}e}f", []string{
		"{a,b{ce}f",
		"{a,b{c{d}e}f"}},
	{"~/{Downloads,Pictures}/*.{jpg,gif,png}", []string{
		"~/Downloads/*.jpg",
		"~/Downloads/*.gif",
		"~/Downloads/*.png",
		"~/Pictures/*.jpg",
		"~/Pictures/*.gif",
		"~/Pictures/*.png"}},
	{"It{{em,alic}iz,erat}e{d,}, please.", []string{
		"Itemized, please.",
		"Itemize, please.",
		"Italicized, please.",
		"Italicize, please.",
		"Iterated, please.",
		"Iterate, please."}},
	{`{,{,gotta have{ ,\, again\, }}more }cowbell!`, []string{
		"cowbell!",
		"more cowbell!",
		"gotta have more cowbell!",
		`gotta have\, again\, more cowbell!`}},
	{`{}} some }{,{\\{ edge, edge} \,}{ cases, {here} \\\\\}`, []string{
		`{}} some }{,{\\ edge \,}{ cases, {here} \\\\\}`,
		`{}} some }{,{\\ edge \,}{ cases, {here} \\\\\}`}},
}

//func ml(l []string) string { return "\n\t" + strings.Join(l, "\n\t") }
func ml(l []string) string {
	var result string
	for _, s := range l {
		result += fmt.Sprintf("\n\t%#q", s)
	}
	return result
}

func TestExpand(t *testing.T) {
	for _, d := range testCases {
		if g := Expand(d.input); !reflect.DeepEqual(g, d.expected) {
			t.Errorf("unexpected result\n Expand(%#q) gave:%v\nExpected:%v",
				d.input, ml(g), ml(d.expected))
		} else {
			// Normally Go tests aren't this verbose, but for rosettacode
			t.Logf("as expected\n Expand(%#q):%v", d.input, ml(g))
		}
	}
}

func BenchmarkExpand(b *testing.B) {
	input := testCases[5].input
	//b.Logf("Benchmarking Expand(%#q)\n", input)
	b.ReportAllocs()
	for i := 0; i < b.N; i++ {
		Expand(input)
	}
}
