package main

import (
    "fmt"
    "sort"
)

func getPrimes(max int) []int {
    if max < 2 {
        return []int{}
    }
    lprimes := []int{2}
outer:
    for x := 3; x <= max; x += 2 {
        for _, p := range lprimes {
            if x%p == 0 {
                continue outer
            }
        }
        lprimes = append(lprimes, x)
    }
    return lprimes
}

func main() {
    const maxSum = 99
    descendants := make([][]int64, maxSum+1)
    ancestors := make([][]int, maxSum+1)
    for i := 0; i <= maxSum; i++ {
        descendants[i] = []int64{}
        ancestors[i] = []int{}
    }
    primes := getPrimes(maxSum)

    for _, p := range primes {
        descendants[p] = append(descendants[p], int64(p))
        for s := 1; s < len(descendants)-p; s++ {
            temp := make([]int64, len(descendants[s]))
            for i := 0; i < len(descendants[s]); i++ {
                temp[i] = int64(p) * descendants[s][i]
            }
            descendants[s+p] = append(descendants[s+p], temp...)
        }
    }

    for _, p := range append(primes, 4) {
        le := len(descendants[p])
        if le == 0 {
            continue
        }
        descendants[p][le-1] = 0
        descendants[p] = descendants[p][:le-1]
    }
    total := 0

    for s := 1; s <= maxSum; s++ {
        x := descendants[s]
        sort.Slice(x, func(i, j int) bool {
            return x[i] < x[j]
        })
        total += len(descendants[s])
        index := 0
        for ; index < len(descendants[s]); index++ {
            if descendants[s][index] > int64(maxSum) {
                break
            }
        }
        for _, d := range descendants[s][:index] {
            ancestors[d] = append(ancestors[s], s)
        }
        if (s >= 21 && s <= 45) || (s >= 47 && s <= 73) || (s >= 75 && s < maxSum) {
            continue
        }
        temp := fmt.Sprintf("%v", ancestors[s])
        fmt.Printf("%2d: %d Ancestor(s): %-14s", s, len(ancestors[s]), temp)
        le := len(descendants[s])
        if le <= 10 {
            fmt.Printf("%5d Descendant(s): %v\n", le, descendants[s])
        } else {
            fmt.Printf("%5d Descendant(s): %v\b ...]\n", le, descendants[s][:10])
        }
    }
    fmt.Println("\nTotal descendants", total)
}
