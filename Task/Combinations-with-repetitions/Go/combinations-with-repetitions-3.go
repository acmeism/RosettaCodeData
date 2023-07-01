package main

import (
    "fmt"
    "sort"
    "strconv"
)

// Go maps are an easy representation for sets as long as the element type
// of the set is valid as a key type for maps.  Strings are easy.
// We follow the convention of always storing true for the value.
type set      map[string]bool

// Multisets of strings are easy in the same way.
// We store the multiplicity of the element as the value.
type multiset map[string]int

// But multisets are not valid as a map key type so we must do something
// more involved to make a set of multisets, which is the desired return
// type for the combrep function required by the task.  We can store the
// multiset as the value, but we derive a unique string to use as a key.
type msSet    map[string]multiset

// The key method returns this string.  The string will simply be a text
// representation of the contents of the multiset.  The standard
// printable representation of the multiset cannot be used however, because
// Go maps are not ordered.  Instead, the contents are copied to a slice,
// which is sorted to produce something with a printable representation
// that will compare == for mathematically equal multisets.
//
// Of course there is overhead for this and if performance were important,
// a different representation would be used for multisets, one that didn’t
// require sorting to produce a key...
func (m multiset) key() string {
    pl := make(pairList, len(m))
    i := 0
    for k, v := range m {
        pl[i] = msPair{k, v}
	i++
    }
    sort.Sort(pl)
    return fmt.Sprintf("%v", pl)
}

// Types and methods needed for sorting inside of mulitset.key()
type msPair struct {
    string
    int
}
type pairList []msPair
func (p pairList) Len() int { return len(p) }
func (p pairList) Swap(i, j int) { p[i], p[j] = p[j], p[i] }
func (p pairList) Less(i, j int) bool { return p[i].string < p[j].string }

// Function required by task.
func combrep(n int, lst set) msSet {
    if n == 0 {
        var ms multiset
        return msSet{ms.key(): ms}
    }
    if len(lst) == 0 {
        return msSet{}
    }
    var car string
    var cdr set
    for ele := range lst {
        if cdr == nil {
            car = ele
            cdr = make(set)
        } else {
            cdr[ele] = true
        }
    }
    r := combrep(n, cdr)

    for _, x := range combrep(n-1, lst) {
        c := multiset{car: 1}
        for k, v := range x {
            c[k] += v
        }
        r[c.key()] = c
    }
    return r
}

// Driver for examples required by task.
func main() {
    // Input is a set.
    three := set{"iced": true, "jam": true, "plain": true}
    // Output is a set of multisets.  The set is a Go map:
    // The key is a string representation that compares equal
    // for equal multisets.  We ignore this here.  The value
    // is the multiset.  We print this.
    for _, ms := range combrep(2, three) {
        fmt.Println(ms)
    }
    ten := make(set)
    for i := 1; i <= 10; i++ {
        ten[strconv.Itoa(i)] = true
    }
    fmt.Println(len(combrep(3, ten)))
}
