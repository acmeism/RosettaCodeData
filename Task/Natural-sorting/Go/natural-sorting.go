package main

import (
    "fmt"
    "regexp"
    "sort"
    "strconv"
    "strings"
)

var tests = []struct {
    descr string
    list  []string
}{
    {"Ignoring leading spaces", []string{
        "ignore leading spaces: 2-2",
        " ignore leading spaces: 2-1",
        "  ignore leading spaces: 2+0",
        "   ignore leading spaces: 2+1",
    }},
    {"Ignoring multiple adjacent spaces", []string{
        "ignore m.a.s spaces: 2-2",
        "ignore m.a.s  spaces: 2-1",
        "ignore m.a.s   spaces: 2+0",
        "ignore m.a.s    spaces: 2+1",
    }},
    {"Equivalent whitespace characters", []string{
        "Equiv. spaces: 3-3",
        "Equiv.\rspaces: 3-2",
        "Equiv.\fspaces: 3-1",
        "Equiv.\bspaces: 3+0",
        "Equiv.\nspaces: 3+1",
        "Equiv.\tspaces: 3+2",
    }},
    {"Case Indepenent sort", []string{
        "cASE INDEPENENT: 3-2",
        "caSE INDEPENENT: 3-1",
        "casE INDEPENENT: 3+0",
        "case INDEPENENT: 3+1",
    }},
    {"Numeric fields as numerics", []string{
        "foo100bar99baz0.txt",
        "foo100bar10baz0.txt",
        "foo1000bar99baz10.txt",
        "foo1000bar99baz9.txt",
    }},
}

func main() {
    for _, test := range tests {
        fmt.Println(test.descr)
        fmt.Println("Input order:")
        for _, s := range test.list {
            fmt.Printf("   %q\n", s)
        }
        fmt.Println("Natural order:")
        l := make(list, len(test.list))
        for i, s := range test.list {
            l[i] = newNatStr(s)
        }
        sort.Sort(l)
        for _, s := range l {
            fmt.Printf("   %q\n", s.s)
        }
        fmt.Println()
    }
}

// natStr associates a string with a preprocessed form
type natStr struct {
    s string // original
    t []tok  // preprocessed "sub-fields"
}

func newNatStr(s string) (t natStr) {
    t.s = s
    s = strings.ToLower(strings.Join(strings.Fields(s), " "))
    x := dx.FindAllString(s, -1)
    t.t = make([]tok, len(x))
    for i, s := range x {
        if n, err := strconv.Atoi(s); err == nil {
            t.t[i].n = n
        } else {
            t.t[i].s = s
        }
    }
    return t
}

var dx = regexp.MustCompile(`\d+|\D+`)

// rule is to use s unless it is empty, then use n
type tok struct {
    s string
    n int
}

// rule 2 of "numeric sub-fields" from talk page
func (f1 tok) Cmp(f2 tok) int {
    switch {
    case f1.s == "":
        switch {
        case f2.s > "" || f1.n < f2.n:
            return -1
        case f1.n > f2.n:
            return 1
        }
    case f2.s == "" || f1.s > f2.s:
        return 1
    case f1.s < f2.s:
        return -1
    }
    return 0
}

type list []natStr

func (l list) Len() int      { return len(l) }
func (l list) Swap(i, j int) { l[i], l[j] = l[j], l[i] }
func (l list) Less(i, j int) bool {
    ti := l[i].t
    for k, t := range l[j].t {
        if k == len(ti) {
            return true
        }
        switch ti[k].Cmp(t) {
        case -1:
            return true
        case 1:
            return false
        }
    }
    return false
}
