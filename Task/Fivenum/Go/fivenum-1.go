package main

import (
    "fmt"
    "math"
    "sort"
)

func fivenum(a []float64) (n5 [5]float64) {
    sort.Float64s(a)
    n := float64(len(a))
    n4 := float64((len(a)+3)/2) / 2
    d := []float64{1, n4, (n + 1) / 2, n + 1 - n4, n}
    for e, de := range d {
        floor := int(de - 1)
        ceil := int(math.Ceil(de - 1))
        n5[e] = .5 * (a[floor] + a[ceil])
    }
    return
}

var (
    x1 = []float64{36, 40, 7, 39, 41, 15}
    x2 = []float64{15, 6, 42, 41, 7, 36, 49, 40, 39, 47, 43}
    x3 = []float64{
        0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594,
        0.73438555, -0.03035726, 1.46675970, -0.74621349, -0.72588772,
        0.63905160, 0.61501527, -0.98983780, -1.00447874, -0.62759469,
        0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578,
    }
)

func main() {
    fmt.Println(fivenum(x1))
    fmt.Println(fivenum(x2))
    fmt.Println(fivenum(x3))
}
