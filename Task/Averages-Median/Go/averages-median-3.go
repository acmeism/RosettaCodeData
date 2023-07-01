package main

import (
    "fmt"
    "math/rand"
)

func main() {
    fmt.Println(median([]float64{3, 1, 4, 1}))    // prints 2
    fmt.Println(median([]float64{3, 1, 4, 1, 5})) // prints 3
}

func median(list []float64) float64 {
    half := len(list) / 2
    med := qsel(list, half)
    if len(list)%2 == 0 {
        return (med + qsel(list, half-1)) / 2
    }
    return med
}

func qsel(a []float64, k int) float64 {
    for len(a) > 1 {
        px := rand.Intn(len(a))
        pv := a[px]
        last := len(a) - 1
        a[px], a[last] = a[last], pv
        px = 0
        for i, v := range a[:last] {
            if v < pv {
                a[px], a[i] = v, a[px]
                px++
            }
        }
        if px == k {
            return pv
        }
        if k < px {
            a = a[:px]
        } else {
            // swap elements.  simply assigning a[last] would be enough to
            // allow qsel to return the correct result but it would leave slice
            // "a" unusable for subsequent use.  we want this full swap so that
            // we can make two successive qsel calls in the case of median
            // of an even number of elements.
            a[px], a[last] = pv, a[px]
            a = a[px+1:]
            k -= px + 1
        }
    }
    return a[0]
}
