package main

import (
    "fmt"
    "sort"
)

func distinctSortedUnion(ll [][]int) []int {
    var res []int
    for _, l := range ll {
        res = append(res, l...)
    }
    set := make(map[int]bool)
    for _, e := range res {
        set[e] = true
    }
    res = res[:0]
    for key := range set {
        res = append(res, key)
    }
    sort.Ints(res)
    return res
}

func main() {
    ll := [][]int{{5, 1, 3, 8, 9, 4, 8, 7}, {3, 5, 9, 8, 4}, {1, 3, 7, 9}}
    fmt.Println("Distinct sorted union of", ll, "is:")
    fmt.Println(distinctSortedUnion(ll))
}
