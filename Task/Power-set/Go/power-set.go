package main

import (
	"bytes"
	"fmt"
	"strconv"
)

// types needed to implement general purpose sets are element and set

// element is an interface, allowing different kinds of elements to be
// implemented and stored in sets.
type elem interface {
	// an element must be distinguishable from other elements to satisfy
	// the mathematical definition of a set.  a.eq(b) must give the same
	// result as b.eq(a).
	Eq(elem) bool
	// String result is used only for printable output.  Given a, b where
	// a.eq(b), it is not required that a.String() == b.String().
	fmt.Stringer
}

// integer type satisfying element interface
type Int int

func (i Int) Eq(e elem) bool {
	j, ok := e.(Int)
	return ok && i == j
}

func (i Int) String() string {
	return strconv.Itoa(int(i))
}

// a set is a slice of elem's.  methods are added to implement
// the element interface, to allow nesting.
type set []elem

// uniqueness of elements can be ensured by using add method
func (s *set) add(e elem) {
	if !s.has(e) {
		*s = append(*s, e)
	}
}

func (s *set) has(e elem) bool {
	for _, ex := range *s {
		if e.Eq(ex) {
			return true
		}
	}
	return false
}

// elem.Eq
func (s set) Eq(e elem) bool {
	t, ok := e.(set)
	if !ok {
		return false
	}
	if len(s) != len(t) {
		return false
	}
	for _, se := range s {
		if !t.has(se) {
			return false
		}
	}
	return true
}

// elem.String
func (s set) String() string {
	if len(s) == 0 {
		return "∅"
	}
	var buf bytes.Buffer
	buf.WriteRune('{')
	for i, e := range s {
		if i > 0 {
			buf.WriteRune(',')
		}
		buf.WriteString(e.String())
	}
	buf.WriteRune('}')
	return buf.String()
}

// method required for task
func (s set) powerSet() set {
	r := set{set{}}
	for _, es := range s {
		var u set
		for _, er := range r {
			u = append(u, append(er.(set), es))
		}
		r = append(r, u...)
	}
	return r
}

func main() {
	var s set
	for _, i := range []Int{1, 2, 2, 3, 4, 4, 4} {
		s.add(i)
	}
	fmt.Println("      s:", s, "length:", len(s))
	ps := s.powerSet()
	fmt.Println("   𝑷(s):", ps, "length:", len(ps))

	var empty set
	fmt.Println("  empty:", empty, "len:", len(empty))
	ps = empty.powerSet()
	fmt.Println("   𝑷(∅):", ps, "len:", len(ps))
	ps = ps.powerSet()
	fmt.Println("𝑷(𝑷(∅)):", ps, "len:", len(ps))
}
