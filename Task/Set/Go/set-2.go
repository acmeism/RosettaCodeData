package main

import (
    "fmt"
    "math/big"
)

func main() {
    // create an empty set
    var s0 big.Int

    // create sets with elements
    s1 := newSet(3)
    s2 := newSet(3, 1)
    s3 := newSet(3, 1, 4, 1, 5, 9)

    // output
    fmt.Println("s0:", format(s0))
    fmt.Println("s1:", format(s1))
    fmt.Println("s2:", format(s2))
    fmt.Println("s3:", format(s3))

    // element predicate
    fmt.Printf("%v ∈ s0: %t\n", 3, hasElement(s0, 3))
    fmt.Printf("%v ∈ s3: %t\n", 3, hasElement(s3, 3))
    fmt.Printf("%v ∈ s3: %t\n", 2, hasElement(s3, 2))

    // union
    b := newSet(4, 2)
    fmt.Printf("s3 ∪ %v: %v\n", format(b), format(union(s3, b)))

    // intersection
    fmt.Printf("s3 ∩ %v: %v\n", format(b), format(intersection(s3, b)))

    // difference
    fmt.Printf("s3 \\ %v: %v\n", format(b), format(difference(s3, b)))

    // subset predicate
    fmt.Printf("%v ⊆ s3: %t\n", format(b), subset(b, s3))
    fmt.Printf("%v ⊆ s3: %t\n", format(s2), subset(s2, s3))
    fmt.Printf("%v ⊆ s3: %t\n", format(s0), subset(s0, s3))

    // equality
    s2Same := newSet(1, 3)
    fmt.Printf("%v = s2: %t\n", format(s2Same), equal(s2Same, s2))

    // proper subset
    fmt.Printf("%v ⊂ s2: %t\n", format(s2Same), properSubset(s2Same, s2))
    fmt.Printf("%v ⊂ s3: %t\n", format(s2Same), properSubset(s2Same, s3))

    // delete
    remove(&s3, 3)
    fmt.Println("s3, 3 removed:", format(s3))
}

func newSet(ms ...int) (set big.Int) {
    for _, m := range ms {
        set.SetBit(&set, m, 1)
    }
    return
}

func remove(set *big.Int, m int) {
    set.SetBit(set, m, 0)
}

func format(set big.Int) string {
    if len(set.Bits()) == 0 {
        return "∅"
    }
    r := "{"
    for e, l := 0, set.BitLen(); e < l; e++ {
        if set.Bit(e) == 1 {
            r = fmt.Sprintf("%s%v, ", r, e)
        }
    }
    return r[:len(r)-2] + "}"
}

func hasElement(set big.Int, m int) bool {
    return set.Bit(m) == 1
}

func union(a, b big.Int) (set big.Int) {
    set.Or(&a, &b)
    return
}

func intersection(a, b big.Int) (set big.Int) {
    set.And(&a, &b)
    return
}

func difference(a, b big.Int) (set big.Int) {
    set.AndNot(&a, &b)
    return
}

func subset(a, b big.Int) bool {
    ab := a.Bits()
    bb := b.Bits()
    if len(ab) > len(bb) {
        return false
    }
    for i, aw := range ab {
        if aw&^bb[i] != 0 {
            return false
        }
    }
    return true
}

func equal(a, b big.Int) bool {
    return a.Cmp(&b) == 0
}

func properSubset(a, b big.Int) (p bool) {
    ab := a.Bits()
    bb := b.Bits()
    if len(ab) > len(bb) {
        return false
    }
    for i, aw := range ab {
        bw := bb[i]
        if aw&^bw != 0 {
            return false
        }
        if aw != bw {
            p = true
        }
    }
    return
}
