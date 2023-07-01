package main

import (
    "fmt"
    "math/big"
)

var (
    p   = map[int]int{1: 0}
    lvl = [][]int{[]int{1}}
)

func path(n int) []int {
    if n == 0 {
        return []int{}
    }
    for {
        if _, ok := p[n]; ok {
            break
        }
        var q []int
        for _, x := range lvl[0] {
            for _, y := range path(x) {
                z := x + y
                if _, ok := p[z]; ok {
                    break
                }
                p[z] = x
                q = append(q, z)
            }
        }
        lvl[0] = q
    }
    r := path(p[n])
    r = append(r, n)
    return r
}

func treePow(x float64, n int) *big.Float {
    r := map[int]*big.Float{0: big.NewFloat(1), 1: big.NewFloat(x)}
    p := 0
    for _, i := range path(n) {
        temp := new(big.Float).SetPrec(320)
        temp.Mul(r[i-p], r[p])
        r[i] = temp
        p = i
    }
    return r[n]
}

func showPow(x float64, n int, isIntegral bool) {
    fmt.Printf("%d: %v\n", n, path(n))
    f := "%f"
    if isIntegral {
        f = "%.0f"
    }
    fmt.Printf(f, x)
    fmt.Printf(" ^ %d = ", n)
    fmt.Printf(f+"\n\n", treePow(x, n))
}

func main() {
    for n := 0; n <= 17; n++ {
        showPow(2, n, true)
    }
    showPow(1.1, 81, false)
    showPow(3, 191, true)
}
