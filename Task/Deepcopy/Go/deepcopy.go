package main

import "fmt"

// a complex data structure
type cds struct {
    i int            // no special handling needed for deep copy
    s string         // no special handling
    b []byte         // copied easily with append function
    m map[int]bool   // deep copy requires looping
}

// a method
func (c cds) deepcopy() *cds {
    // copy what you can in one line
    r := &cds{c.i, c.s, append([]byte{}, c.b...), make(map[int]bool)}
    // populate map with a loop
    for k, v := range c.m {
        r.m[k] = v
    }
    return r
}

// demo
func main() {
    // create and populate a structure
    c1 := &cds{1, "one", []byte("unit"), map[int]bool{1: true}}
    fmt.Println(c1)      // show it
    c2 := c1.deepcopy()  // copy it
    fmt.Println(c2)      // show copy
    c1.i = 0             // change original
    c1.s = "nil"
    copy(c1.b, "zero")
    c1.m[1] = false
    fmt.Println(c1)      // show changes
    fmt.Println(c2)      // show copy unaffected
}
