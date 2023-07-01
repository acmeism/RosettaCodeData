package main

import (
    "fmt"
    "math"
    "rcu"
)

var maxDepth = 6
var maxBase = 36
var c = rcu.PrimeSieve(int(math.Pow(float64(maxBase), float64(maxDepth))), true)
var digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
var maxStrings [][][]int
var mostBases = -1

func maxSlice(a []int) int {
    max := 0
    for _, e := range a {
        if e > max {
            max = e
        }
    }
    return max
}

func maxInt(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func process(indices []int) {
    minBase := maxInt(2, maxSlice(indices)+1)
    if maxBase - minBase + 1 < mostBases {
        return  // can't affect results so return
    }
    var bases []int
    for b := minBase; b <= maxBase; b++ {
        n := 0
        for _, i := range indices {
            n = n*b + i
        }
        if !c[n] {
            bases = append(bases, b)
        }
    }
    count := len(bases)
    if count > mostBases {
        mostBases = count
        indices2 := make([]int, len(indices))
        copy(indices2, indices)
        maxStrings = [][][]int{[][]int{indices2, bases}}
    } else if count == mostBases {
        indices2 := make([]int, len(indices))
        copy(indices2, indices)
        maxStrings = append(maxStrings, [][]int{indices2, bases})
    }
}

func printResults() {
    fmt.Printf("%d\n", len(maxStrings[0][1]))
    for _, m := range maxStrings {
        s := ""
        for _, i := range m[0] {
            s = s + string(digits[i])
        }
        fmt.Printf("%s -> %v\n", s, m[1])
    }
}

func nestedFor(indices []int, length, level int) {
    if level == len(indices) {
        process(indices)
    } else {
        indices[level] = 0
        if level == 0 {
            indices[level] = 1
        }
        for indices[level] < length {
            nestedFor(indices, length, level+1)
            indices[level]++
        }
    }
}

func main() {
    for depth := 1; depth <= maxDepth; depth++ {
        fmt.Print(depth, " character strings which are prime in most bases: ")
        maxStrings = maxStrings[:0]
        mostBases = -1
        indices := make([]int, depth)
        nestedFor(indices, maxBase, 0)
        printResults()
        fmt.Println()
    }
}
