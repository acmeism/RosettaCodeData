package main

import (
    "fmt"
    "math"
)

var supply = []int{461, 277, 356, 488, 393}
var demand = []int{278, 60, 461, 116, 1060}

var costs = make([][]int, nRows)

var nRows = len(supply)
var nCols = len(demand)

var rowDone = make([]bool, nRows)
var colDone = make([]bool, nCols)
var results = make([][]int, nRows)

func init() {
    costs[0] = []int{46, 74, 9, 28, 99}
    costs[1] = []int{12, 75, 6, 36, 48}
    costs[2] = []int{35, 199, 4, 5, 71}
    costs[3] = []int{61, 81, 44, 88, 9}
    costs[4] = []int{85, 60, 14, 25, 79}

    for i := 0; i < len(results); i++ {
        results[i] = make([]int, nCols)
    }
}

// etc

func main() {
    // etc

    fmt.Println("     A    B    C    D    E")
    for i, result := range results {
        fmt.Printf("%c", 'V'+i)
        for _, item := range result {
            fmt.Printf("  %3d", item)
        }
        fmt.Println()
    }
    fmt.Println("\nTotal cost =", totalCost)
}
