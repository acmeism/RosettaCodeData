package main

import (
    "fmt"
    "math/rand"
)

// returns permutation q of n items, using Myrvold-Ruskey rank.
func MRPerm(q, n int) []int {
    p := ident(n)
    var r int
    for n > 0 {
        q, r = q/n, q%n
        n--
        p[n], p[r] = p[r], p[n]
    }
    return p
}

// returns identity permutation of n items.
func ident(n int) []int {
    p := make([]int, n)
    for i := range p {
        p[i] = i
    }
    return p
}

// returns Myrvold-Ruskey rank of permutation p
func MRRank(p []int) (r int) {
    p = append([]int{}, p...)
    inv := inverse(p)
    for i := len(p) - 1; i > 0; i-- {
        s := p[i]
        p[inv[i]] = s
        inv[s] = inv[i]
    }
    for i := 1; i < len(p); i++ {
        r = r*(i+1) + p[i]
    }
    return
}

// returns inverse of a permutation.
func inverse(p []int) []int {
    r := make([]int, len(p))
    for i, x := range p {
        r[x] = i
    }
    return r
}

// returns n!
func fact(n int) (f int) {
    for f = n; n > 2; {
        n--
        f *= n
    }
    return
}

func main() {
    n := 3
    fmt.Println("permutations of", n, "items")
    f := fact(n)
    for i := 0; i < f; i++ {
        p := MRPerm(i, n)
        fmt.Println(i, p, MRRank(p))
    }
    n = 12
    fmt.Println("permutations of", n, "items")
    f = fact(n)
    m := map[int]bool{}
    for len(m) < 4 {
        r := rand.Intn(f)
        if m[r] {
            continue
        }
        m[r] = true
        fmt.Println(r, MRPerm(r, n))
    }
}
