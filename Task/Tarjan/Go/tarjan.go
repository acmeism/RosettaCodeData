package main

import (
    "fmt"
    "math/big"
)

// (same data as zkl example)
var g = [][]int{
    0: {1},
    2: {0},
    5: {2, 6},
    6: {5},
    1: {2},
    3: {1, 2, 4},
    4: {5, 3},
    7: {4, 7, 6},
}

func main() {
    tarjan(g, func(c []int) { fmt.Println(c) })
}

// the function calls the emit argument for each component identified.
// each component is a list of nodes.
func tarjan(g [][]int, emit func([]int)) {
    var indexed, stacked big.Int
    index := make([]int, len(g))
    lowlink := make([]int, len(g))
    x := 0
    var S []int
    var sc func(int) bool
    sc = func(n int) bool {
        index[n] = x
        indexed.SetBit(&indexed, n, 1)
        lowlink[n] = x
        x++
        S = append(S, n)
        stacked.SetBit(&stacked, n, 1)
        for _, nb := range g[n] {
            if indexed.Bit(nb) == 0 {
                if !sc(nb) {
                    return false
                }
                if lowlink[nb] < lowlink[n] {
                    lowlink[n] = lowlink[nb]
                }
            } else if stacked.Bit(nb) == 1 {
                if index[nb] < lowlink[n] {
                    lowlink[n] = index[nb]
                }
            }
        }
        if lowlink[n] == index[n] {
            var c []int
            for {
                last := len(S) - 1
                w := S[last]
                S = S[:last]
                stacked.SetBit(&stacked, w, 0)
                c = append(c, w)
                if w == n {
                    emit(c)
                    break
                }
            }
        }
        return true
    }
    for n := range g {
        if indexed.Bit(n) == 0 && !sc(n) {
            return
        }
    }
}
