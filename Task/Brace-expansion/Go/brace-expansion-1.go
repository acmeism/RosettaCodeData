package expand

// Expander is anything that can be expanded into a slice of strings.
type Expander interface {
	Expand() []string
}

// Text is a trivial Expander that expands to a slice with just itself.
type Text string

func (t Text) Expand() []string { return []string{string(t)} }

// Alternation is an Expander that expands to the union of its
// members' expansions.
type Alternation []Expander

func (alt Alternation) Expand() []string {
	var out []string
	for _, e := range alt {
		out = append(out, e.Expand()...)
	}
	return out
}

// Sequence is an Expander that expands to the combined sequence of its
// members' expansions.
type Sequence []Expander

func (seq Sequence) Expand() []string {
	if len(seq) == 0 {
		return nil
	}
	out := seq[0].Expand()
	for _, e := range seq[1:] {
		out = combine(out, e.Expand())
	}
	return out
}

func combine(al, bl []string) []string {
	out := make([]string, 0, len(al)*len(bl))
	for _, a := range al {
		for _, b := range bl {
			out = append(out, a+b)
		}
	}
	return out
}

// Currently only single byte runes are supported for these.
const (
	escape   = '\\'
	altStart = '{'
	altEnd   = '}'
	altSep   = ','
)

type piT struct{ pos, cnt, depth int }

type Brace string

// Expand takes an input string and returns the expanded list of
// strings. The input string can contain any number of nested
// alternation specifications of the form "{A,B}" which is expanded to
// the strings "A", then "B".
//
// E.g. Expand("a{2,1}b{X,Y,X}c") returns ["a2bXc", "a2bYc", "a2bXc",
// "a1bXc", "a1bYc", "a1bXc"].
//
// Unmatched '{', ',', and '}' characters are passed through to the
// output. The special meaning of these characters can be escaped with
// '\', (which itself can be escaped).
// Escape characters are not removed, but passed through to the output.
func Expand(s string) []string   { return Brace(s).Expand() }
func (b Brace) Expand() []string { return b.Expander().Expand() }
func (b Brace) Expander() Expander {
	s := string(b)
	//log.Printf("Exapand(%#q)\n", s)
	var posInfo []piT
	var stack []int // indexes into posInfo
	removePosInfo := func(i int) {
		end := len(posInfo) - 1
		copy(posInfo[i:end], posInfo[i+1:])
		posInfo = posInfo[:end]
	}

	inEscape := false
	for i, r := range s {
		if inEscape {
			inEscape = false
			continue
		}
		switch r {
		case escape:
			inEscape = true
		case altStart:
			stack = append(stack, len(posInfo))
			posInfo = append(posInfo, piT{i, 0, len(stack)})
		case altEnd:
			if len(stack) == 0 {
				continue
			}
			si := len(stack) - 1
			pi := stack[si]
			if posInfo[pi].cnt == 0 {
				removePosInfo(pi)
				for pi < len(posInfo) {
					if posInfo[pi].depth == len(stack) {
						removePosInfo(pi)
					} else {
						pi++
					}
				}
			} else {
				posInfo = append(posInfo, piT{i, -2, len(stack)})
			}
			stack = stack[:si]
		case altSep:
			if len(stack) == 0 {
				continue
			}
			posInfo = append(posInfo, piT{i, -1, len(stack)})
			posInfo[stack[len(stack)-1]].cnt++
		}
	}
	//log.Println("stack:", stack)
	for len(stack) > 0 {
		si := len(stack) - 1
		pi := stack[si]
		depth := posInfo[pi].depth
		removePosInfo(pi)
		for pi < len(posInfo) {
			if posInfo[pi].depth == depth {
				removePosInfo(pi)
			} else {
				pi++
			}
		}
		stack = stack[:si]
	}
	return buildExp(s, 0, posInfo)
}

func buildExp(s string, off int, info []piT) Expander {
	if len(info) == 0 {
		return Text(s)
	}
	//log.Printf("buildExp(%#q, %d, %v)\n", s, off, info)
	var seq Sequence
	i := 0
	var dj, j, depth int
	for dk, piK := range info {
		k := piK.pos - off
		switch s[k] {
		case altStart:
			if depth == 0 {
				dj = dk
				j = k
				depth = piK.depth
			}
		case altEnd:
			if piK.depth != depth {
				continue
			}
			if j > i {
				seq = append(seq, Text(s[i:j]))
			}
			alt := buildAlt(s[j+1:k], depth, j+1+off, info[dj+1:dk])
			seq = append(seq, alt)
			i = k + 1
			depth = 0
		}
	}
	if j := len(s); j > i {
		seq = append(seq, Text(s[i:j]))
	}
	if len(seq) == 1 {
		return seq[0]
	}
	return seq
}

func buildAlt(s string, depth, off int, info []piT) Alternation {
	//log.Printf("buildAlt(%#q, %d, %d, %v)\n", s, depth, off, info)
	var alt Alternation
	i := 0
	var di int
	for dk, piK := range info {
		if piK.depth != depth {
			continue
		}
		if k := piK.pos - off; s[k] == altSep {
			sub := buildExp(s[i:k], i+off, info[di:dk])
			alt = append(alt, sub)
			i = k + 1
			di = dk + 1
		}
	}
	sub := buildExp(s[i:], i+off, info[di:])
	alt = append(alt, sub)
	return alt
}
