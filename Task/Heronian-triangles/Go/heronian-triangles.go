package main

import (
    "fmt"
    "math"
    "sort"
)

const (
    n = 200
    header = "\nSides          P   A"
)

func gcd(a, b int) int {
    leftover := 1
    var dividend, divisor int
    if (a > b) { dividend, divisor = a, b } else { dividend, divisor = b, a }

    for (leftover != 0) {
        leftover = dividend % divisor
        if (leftover > 0) {
            dividend, divisor = divisor, leftover
        }
    }
    return divisor
}

func is_heron(h float64) bool {
    return h > 0 && math.Mod(h, 1) == 0.0
}

// by_area_perimeter implements sort.Interface for [][]int based on the area first and perimeter value
type by_area_perimeter [][]int

func (a by_area_perimeter) Len() int           { return len(a) }
func (a by_area_perimeter) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a by_area_perimeter) Less(i, j int) bool {
    return a[i][4] < a[j][4] || a[i][4] == a[j][4] && a[i][3] < a[j][3]
}

func main() {
    var l [][]int
    for c := 1; c <= n; c++ {
        for b := 1; b <= c; b++ {
            for a := 1; a <= b; a++ {
                if (gcd(gcd(a, b), c) == 1) {
                    p := a + b + c
                    s := float64(p) / 2.0
                    area := math.Sqrt(s * (s - float64(a)) * (s - float64(b)) * (s - float64(c)))
                    if (is_heron(area)) {
                        l = append(l, []int{a, b, c, p, int(area)})
                    }
                }
            }
        }
    }

    fmt.Printf("Number of primitive Heronian triangles with sides up to %d: %d", n, len(l))
    sort.Sort(by_area_perimeter(l))
    fmt.Printf("\n\nFirst ten when ordered by increasing area, then perimeter:" + header)
    for i := 0; i < 10; i++ { fmt.Printf("\n%3d", l[i]) }

    a := 210
    fmt.Printf("\n\nArea = %d%s", a, header)
    for _, it := range l  {
        if (it[4] == a) {
            fmt.Printf("\n%3d", it)
        }
    }
}
