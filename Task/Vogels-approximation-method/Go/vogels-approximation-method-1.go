package main

import (
    "fmt"
    "math"
)

var supply = []int{50, 60, 50, 50}
var demand = []int{30, 20, 70, 30, 60}

var costs = make([][]int, 4)

var nRows = len(supply)
var nCols = len(demand)

var rowDone = make([]bool, nRows)
var colDone = make([]bool, nCols)
var results = make([][]int, nRows)

func init() {
    costs[0] = []int{16, 16, 13, 22, 17}
    costs[1] = []int{14, 14, 13, 19, 15}
    costs[2] = []int{19, 19, 20, 23, 50}
    costs[3] = []int{50, 12, 50, 15, 11}

    for i := 0; i < len(results); i++ {
        results[i] = make([]int, nCols)
    }
}

func nextCell() []int {
    res1 := maxPenalty(nRows, nCols, true)
    res2 := maxPenalty(nCols, nRows, false)
    switch {
    case res1[3] == res2[3]:
        if res1[2] < res2[2] {
            return res1
        } else {
            return res2
        }
    case res1[3] > res2[3]:
        return res2
    default:
        return res1
    }
}

func diff(j, l int, isRow bool) []int {
    min1 := math.MaxInt32
    min2 := min1
    minP := -1
    for i := 0; i < l; i++ {
        var done bool
        if isRow {
            done = colDone[i]
        } else {
            done = rowDone[i]
        }
        if done {
            continue
        }
        var c int
        if isRow {
            c = costs[j][i]
        } else {
            c = costs[i][j]
        }
        if c < min1 {
            min2, min1, minP = min1, c, i
        } else if c < min2 {
            min2 = c
        }
    }
    return []int{min2 - min1, min1, minP}
}

func maxPenalty(len1, len2 int, isRow bool) []int {
    md := math.MinInt32
    pc, pm, mc := -1, -1, -1
    for i := 0; i < len1; i++ {
        var done bool
        if isRow {
            done = rowDone[i]
        } else {
            done = colDone[i]
        }
        if done {
            continue
        }
        res := diff(i, len2, isRow)
        if res[0] > md {
            md = res[0]  // max diff
            pm = i       // pos of max diff
            mc = res[1]  // min cost
            pc = res[2]  // pos of min cost
        }
    }
    if isRow {
        return []int{pm, pc, mc, md}
    }
    return []int{pc, pm, mc, md}
}

func main() {
    supplyLeft := 0
    for i := 0; i < len(supply); i++ {
        supplyLeft += supply[i]
    }
    totalCost := 0
    for supplyLeft > 0 {
        cell := nextCell()
        r, c := cell[0], cell[1]
        q := demand[c]
        if q > supply[r] {
            q = supply[r]
        }
        demand[c] -= q
        if demand[c] == 0 {
            colDone[c] = true
        }
        supply[r] -= q
        if supply[r] == 0 {
            rowDone[r] = true
        }
        results[r][c] = q
        supplyLeft -= q
        totalCost += q * costs[r][c]
    }

    fmt.Println("    A   B   C   D   E")
    for i, result := range results {
        fmt.Printf("%c", 'W' + i)
        for _, item := range result {
            fmt.Printf("  %2d", item)
        }
        fmt.Println()
    }
    fmt.Println("\nTotal cost =", totalCost)
}
