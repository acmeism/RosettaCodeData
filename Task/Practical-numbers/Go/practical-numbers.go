package main

import (
    "fmt"
    "rcu"
)

func powerset(set []int) [][]int {
    if len(set) == 0 {
        return [][]int{{}}
    }
    head := set[0]
    tail := set[1:]
    p1 := powerset(tail)
    var p2 [][]int
    for _, s := range powerset(tail) {
        h := []int{head}
        h = append(h, s...)
        p2 = append(p2, h)
    }
    return append(p1, p2...)
}

func isPractical(n int) bool {
    if n == 1 {
        return true
    }
    divs := rcu.ProperDivisors(n)
    subsets := powerset(divs)
    found := make([]bool, n) // all false by default
    count := 0
    for _, subset := range subsets {
        sum := rcu.SumInts(subset)
        if sum > 0 && sum < n && !found[sum] {
            found[sum] = true
            count++
            if count == n-1 {
                return true
            }
        }
    }
    return false
}

func main() {
    fmt.Println("In the range 1..333, there are:")
    var practical []int
    for i := 1; i <= 333; i++ {
        if isPractical(i) {
            practical = append(practical, i)
        }
    }
    fmt.Println(" ", len(practical), "practical numbers")
    fmt.Println("  The first ten are", practical[0:10])
    fmt.Println("  The final ten are", practical[len(practical)-10:])
    fmt.Println("\n666 is practical:", isPractical(666))
}
