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


func (t *table) sort(s spec) {
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

    // no "parameters"
    t.sort(spec{})
    t.printRows("sorted on first column")

    // "named parameter" reverse.
    t.sort(spec{reverse: true})
    t.printRows("reverse sorted on first column")

    // "named parameters" column and ordering
    t.sort(spec{
        column:   1,
        ordering: func(a, b cell) bool { return len(a) > len(b) },
    })
    t.printRows("sorted by descending string length on second column")
}
