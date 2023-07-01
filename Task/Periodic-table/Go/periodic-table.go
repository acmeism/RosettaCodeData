package main

import (
    "fmt"
    "log"
)

var limits = [][2]int{
    {3, 10}, {11, 18}, {19, 36}, {37, 54}, {55, 86}, {87, 118},
}

func periodicTable(n int) (int, int) {
    if n < 1 || n > 118 {
        log.Fatal("Atomic number is out of range.")
    }
    if n == 1 {
        return 1, 1
    }
    if n == 2 {
        return 1, 18
    }
    if n >= 57 && n <= 71 {
        return 8, n - 53
    }
    if n >= 89 && n <= 103 {
        return 9, n - 85
    }
    var row, start, end int
    for i := 0; i < len(limits); i++ {
        limit := limits[i]
        if n >= limit[0] && n <= limit[1] {
            row, start, end = i+2, limit[0], limit[1]
            break
        }
    }
    if n < start+2 || row == 4 || row == 5 {
        return row, n - start + 1
    }
    return row, n - end + 18
}

func main() {
    for _, n := range []int{1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113} {
        row, col := periodicTable(n)
        fmt.Printf("Atomic number %3d -> %d, %-2d\n", n, row, col)
    }
}
