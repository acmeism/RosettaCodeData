package main

import "fmt"

func printMinCells(n int) {
    fmt.Printf("Minimum number of cells after, before, above and below %d x %d square:\n", n, n)
    p := 1
    if n > 20 {
        p = 2
    }
    for r := 0; r < n; r++ {
        cells := make([]int, n)
        for c := 0; c < n; c++ {
            nums := []int{n - r - 1, r, c, n - c - 1}
            min := n
            for _, num := range nums {
                if num < min {
                    min = num
                }
            }
            cells[c] = min
        }
        fmt.Printf("%*d \n", p, cells)
    }
}

func main() {
    for _, n := range []int{23, 10, 9, 2, 1} {
        printMinCells(n)
        fmt.Println()
    }
}
