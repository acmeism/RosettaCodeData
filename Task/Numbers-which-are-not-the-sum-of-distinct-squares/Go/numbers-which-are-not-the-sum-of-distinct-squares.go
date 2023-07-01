package main

import (
    "fmt"
    "math"
    "rcu"
)

func contains(a []int, n int) bool {
    for _, e := range a {
        if e == n {
            return true
        }
    }
    return false
}

// recursively permutates the list of squares to seek a matching sum
func soms(n int, f []int) bool {
    if n <= 0 {
        return false
    }
    if contains(f, n) {
        return true
    }
    sum := rcu.SumInts(f)
    if n > sum {
        return false
    }
    if n == sum {
        return true
    }
    rf := make([]int, len(f))
    copy(rf, f)
    for i, j := 0, len(rf)-1; i < j; i, j = i+1, j-1 {
        rf[i], rf[j] = rf[j], rf[i]
    }
    rf = rf[1:]
    return soms(n-f[len(f)-1], rf) || soms(n, rf)
}

func main() {
    var s, a []int
    sf := "\nStopped checking after finding %d sequential non-gaps after the final gap of %d\n"
    i, g := 1, 1
    for g >= (i >> 1) {
        r := int(math.Sqrt(float64(i)))
        if r*r == i {
            s = append(s, i)
        }
        if !soms(i, s) {
            g = i
            a = append(a, g)
        }
        i++
    }
    fmt.Println("Numbers which are not the sum of distinct squares:")
    fmt.Println(a)
    fmt.Printf(sf, i-g, g)
    fmt.Printf("Found %d in total\n", len(a))
}

var r int
