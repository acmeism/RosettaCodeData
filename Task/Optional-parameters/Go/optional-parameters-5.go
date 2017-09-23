package main

import (
    "fmt"
    "sort"
)

type cell string
type row []cell
type table struct {
    rows   []row
    column int
    less   func(cell, cell) bool
}

func (c cell) String() string {
    return fmt.Sprintf("%q", string(c))
}

func (t table) printRows(heading string) {
    fmt.Println("--", heading)
    for _, row := range t.rows {
        fmt.Println(row)
    }
    fmt.Println()
}

// sort.Interface
func (t table) Len() int      { return len(t.rows) }
func (t table) Swap(i, j int) { t.rows[i], t.rows[j] = t.rows[j], t.rows[i] }
func (t table) Less(i, j int) bool {
    return t.less(t.rows[i][t.column], t.rows[j][t.column])
}

// struct implements named parameter-like capability
type spec struct {
    ordering func(cell, cell) bool
    column   int
    reverse  bool
}

// A defined option type is not really needed by the technique, but has
// a nice advantage for documentation.  If this type is exported, then
// the the Go documentation tool go doc will organize all of the option
// functions together under the type.  (Go doc will see them as constructors
// for the type.)
type Option func(*spec)

func ordering(o func(cell, cell) bool) Option {
    return func(s *spec) { s.ordering = o }
}

func column(c int) Option {
    return func(s *spec) { s.column = c }
}

func reverse() Option {
    return func(s *spec) { s.reverse = true }
}

func (t *table) sort(options ...Option) {
    var s spec
    for _, o := range options {
        o(&s)
    }
    // set up column and comparison function for sort
    t.column = s.column
    switch {
    case s.ordering != nil:
        t.less = s.ordering
    case s.reverse:
        t.less = func(a, b cell) bool { return a > b }
    default:
        t.less = func(a, b cell) bool { return a < b }
    }

    // sort
    sort.Sort(t)

    // reverse if necessary
    if s.ordering == nil || !s.reverse {
        return
    }
    last := len(t.rows) - 1
    for i := last / 2; i >= 0; i-- {
        t.rows[i], t.rows[last-i] = t.rows[last-i], t.rows[i]
    }
}

func main() {
    t := table{rows: []row{
        {"pail", "food"},
        {"pillbox", "nurse maids"},
        {"suitcase", "airedales"},
        {"bathtub", "chocolate"},
        {"schooner", "ice cream sodas"},
    }}

    t.printRows("song")
    // no parameters
    t.sort()
    t.printRows("sorted on first column")

    // "named parameter" reverse.
    t.sort(reverse())
    t.printRows("reverse sorted on first column")

    // "named parameters" column and ordering
    byLen := func(a, b cell) bool { return len(a) > len(b) }
    t.sort(column(1), ordering(byLen))
    t.printRows("sorted by descending string length on second column")
}
