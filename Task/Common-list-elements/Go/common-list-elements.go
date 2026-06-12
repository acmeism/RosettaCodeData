package main

import "fmt"

func indexOf(l []int, n int) int {
    for i := 0; i < len(l); i++ {
        if l[i] == n {
            return i
        }
    }
    return -1
}

func common2(l1, l2 []int) []int {
    // minimize number of lookups
    c1, c2 := len(l1), len(l2)
    shortest, longest := l1, l2
    if c1 > c2 {
        shortest, longest = l2, l1
    }
    longest2 := make([]int, len(longest))
    copy(longest2, longest) // matching duplicates will be destructive
    var res []int
    for _, e := range shortest {
        ix := indexOf(longest2, e)
        if ix >= 0 {
            res = append(res, e)
            longest2 = append(longest2[:ix], longest2[ix+1:]...)
        }
    }
    return res
}

func commonN(ll [][]int) []int {
    n := len(ll)
    if n == 0 {
        return []int{}
    }
    if n == 1 {
        return ll[0]
    }
    res := common2(ll[0], ll[1])
    if n == 2 {
        return res
    }
    for _, l := range ll[2:] {
        res = common2(res, l)
    }
    return res
}

func main() {
    lls := [][][]int{
        {{2, 5, 1, 3, 8, 9, 4, 6}, {3, 5, 6, 2, 9, 8, 4}, {1, 3, 7, 6, 9}},
        {{2, 2, 1, 3, 8, 9, 4, 6}, {3, 5, 6, 2, 2, 2, 4}, {2, 3, 7, 6, 2}},
    }
    for _, ll := range lls {
        fmt.Println("Intersection of", ll, "is:")
        fmt.Println(commonN(ll))
        fmt.Println()
    }
}
