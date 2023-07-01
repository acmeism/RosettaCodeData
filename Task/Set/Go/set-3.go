package main

import (
    "fmt"

    "golang.org/x/tools/container/intsets"
)

func main() {
    var s0, s1 intsets.Sparse // create some empty sets
    s1.Insert(3)              // insert an element
    s2 := newSet(3, 1)        // create sets with elements
    s3 := newSet(3, 1, 4, 1, 5, 9)

    // output
    fmt.Println("s0:", &s0)
    fmt.Println("s1:", &s1)
    fmt.Println("s2:", s2)
    fmt.Println("s3:", s3)

    // element predicate
    fmt.Printf("%v ∈ s0: %t\n", 3, s0.Has(3))
    fmt.Printf("%v ∈ s3: %t\n", 3, s3.Has(3))
    fmt.Printf("%v ∈ s3: %t\n", 2, s3.Has(2))

    // union
    b := newSet(4, 2)
    var s intsets.Sparse
    s.Union(s3, b)
    fmt.Printf("s3 ∪ %v: %v\n", b, &s)

    // intersection
    s.Intersection(s3, b)
    fmt.Printf("s3 ∩ %v: %v\n", b, &s)

    // difference
    s.Difference(s3, b)
    fmt.Printf("s3 \\ %v: %v\n", b, &s)

    // subset predicate
    fmt.Printf("%v ⊆ s3: %t\n", b, b.SubsetOf(s3))
    fmt.Printf("%v ⊆ s3: %t\n", s2, s2.SubsetOf(s3))
    fmt.Printf("%v ⊆ s3: %t\n", &s0, s0.SubsetOf(s3))

    // equality
    s2Same := newSet(1, 3)
    fmt.Printf("%v = s2: %t\n", s2Same, s2Same.Equals(s2))

    // delete
    s3.Remove(3)
    fmt.Println("s3, 3 removed:", s3)
}

func newSet(ms ...int) *intsets.Sparse {
    var set intsets.Sparse
    for _, m := range ms {
        set.Insert(m)
    }
    return &set
}
