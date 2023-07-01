package main

import (
    "fmt"
    "sort"
    "strconv"
    "strings"
)

func fairshare(n, base int) []int {
    res := make([]int, n)
    for i := 0; i < n; i++ {
        j := i
        sum := 0
        for j > 0 {
            sum += j % base
            j /= base
        }
        res[i] = sum % base
    }
    return res
}

func turns(n int, fss []int) string {
    m := make(map[int]int)
    for _, fs := range fss {
        m[fs]++
    }
    m2 := make(map[int]int)
    for _, v := range m {
        m2[v]++
    }
    res := []int{}
    sum := 0
    for k, v := range m2 {
        sum += v
        res = append(res, k)
    }
    if sum != n {
        return fmt.Sprintf("only %d have a turn", sum)
    }
    sort.Ints(res)
    res2 := make([]string, len(res))
    for i := range res {
        res2[i] = strconv.Itoa(res[i])
    }
    return strings.Join(res2, " or ")
}

func main() {
    for _, base := range []int{2, 3, 5, 11} {
        fmt.Printf("%2d : %2d\n", base, fairshare(25, base))
    }
    fmt.Println("\nHow many times does each get a turn in 50000 iterations?")
    for _, base := range []int{191, 1377, 49999, 50000, 50001} {
        t := turns(base, fairshare(50000, base))
        fmt.Printf("  With %d people: %s\n", base, t)
    }
}
