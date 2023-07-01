package main

import (
    "fmt"
    "strings"
)

func btoi(b bool) int {
    if b {
        return 1
    }
    return 0
}

func evolve(l, rule int) {
    fmt.Printf(" Rule #%d:\n", rule)
    cells := "O"
    for x := 0; x < l; x++ {
        cells = addNoCells(cells)
        width := 40 + (len(cells) >> 1)
        fmt.Printf("%*s\n", width, cells)
        cells = step(cells, rule)
    }
}

func step(cells string, rule int) string {
    newCells := new(strings.Builder)
    for i := 0; i < len(cells)-2; i++ {
        bin := 0
        b := uint(2)
        for n := i; n < i+3; n++ {
            bin += btoi(cells[n] == 'O') << b
            b >>= 1
        }
        a := '.'
        if rule&(1<<uint(bin)) != 0 {
            a = 'O'
        }
        newCells.WriteRune(a)
    }
    return newCells.String()
}

func addNoCells(cells string) string {
    l, r := "O", "O"
    if cells[0] == 'O' {
        l = "."
    }
    if cells[len(cells)-1] == 'O' {
        r = "."
    }
    cells = l + cells + r
    cells = l + cells + r
    return cells
}

func main() {
    for _, r := range []int{90, 30} {
        evolve(25, r)
        fmt.Println()
    }
}
