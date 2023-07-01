package main

import "fmt"

var canFollow [][]bool
var arrang []int
var bFirst = true

var pmap = make(map[int]bool)

func init() {
    for _, i := range []int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37} {
        pmap[i] = true
    }
}

func ptrs(res, n, done int) int {
    ad := arrang[done-1]
    if n-done <= 1 {
        if canFollow[ad-1][n-1] {
            if bFirst {
                for _, e := range arrang {
                    fmt.Printf("%2d ", e)
                }
                fmt.Println()
                bFirst = false
            }
            res++
        }
    } else {
        done++
        for i := done - 1; i <= n-2; i += 2 {
            ai := arrang[i]
            if canFollow[ad-1][ai-1] {
                arrang[i], arrang[done-1] = arrang[done-1], arrang[i]
                res = ptrs(res, n, done)
                arrang[i], arrang[done-1] = arrang[done-1], arrang[i]
            }
        }
    }
    return res
}

func primeTriangle(n int) int {
    canFollow = make([][]bool, n)
    for i := 0; i < n; i++ {
        canFollow[i] = make([]bool, n)
        for j := 0; j < n; j++ {
            _, ok := pmap[i+j+2]
            canFollow[i][j] = ok
        }
    }
    bFirst = true
    arrang = make([]int, n)
    for i := 0; i < n; i++ {
        arrang[i] = i + 1
    }
    return ptrs(0, n, 1)
}

func main() {
    counts := make([]int, 19)
    for i := 2; i <= 20; i++ {
        counts[i-2] = primeTriangle(i)
    }
    fmt.Println()
    for i := 0; i < 19; i++ {
        fmt.Printf("%d ", counts[i])
    }
    fmt.Println()
}
