package main

import "fmt"

func main() {
    // Example 1:  Idiomatic in Go is use of the append function.
    // Elements must be of identical type.
    a := []int{1, 2, 3}
    b := []int{7, 12, 60} // these are technically slices, not arrays
    c := append(a, b...)
    fmt.Println(c)

    // Example 2:  Polymorphism.
    // interface{} is a type too, one that can reference values of any type.
    // This allows a sort of polymorphic list.
    i := []interface{}{1, 2, 3}
    j := []interface{}{"Crosby", "Stills", "Nash", "Young"}
    k := append(i, j...) // append will allocate as needed
    fmt.Println(k)

    // Example 3:  Arrays, not slices.
    // A word like "array" on RC often means "whatever array means in your
    // language."  In Go, the common role of "array" is usually filled by
    // Go slices, as in examples 1 and 2.  If by "array" you really mean
    // "Go array," then you have to do a little extra work.  The best
    // technique is almost always to create slices on the arrays and then
    // use the copy function.
    l := [...]int{1, 2, 3}
    m := [...]int{7, 12, 60} // arrays have constant size set at compile time
    var n [len(l) + len(m)]int
    copy(n[:], l[:]) // [:] creates a slice that references the entire array
    copy(n[len(l):], m[:])
    fmt.Println(n)

}
