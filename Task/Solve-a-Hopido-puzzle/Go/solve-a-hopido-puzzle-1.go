package main

import (
    "fmt"
    "sort"
)

var board = []string{
    ".00.00.",
    "0000000",
    "0000000",
    ".00000.",
    "..000..",
    "...0...",
}

var moves = [][2]int{
    {-3, 0}, {0, 3}, {3, 0}, {0, -3},
    {2, 2}, {2, -2}, {-2, 2}, {-2, -2},
}

var grid [][]int

var totalToFill = 0

func solve(r, c, count int) bool {
    if count > totalToFill {
        return true
    }
    nbrs := neighbors(r, c)
    if len(nbrs) == 0 && count != totalToFill {
        return false
    }
    sort.Slice(nbrs, func(i, j int) bool {
        return nbrs[i][2] < nbrs[j][2]
    })

    for _, nb := range nbrs {
        r = nb[0]
        c = nb[1]
        grid[r][c] = count
        if solve(r, c, count+1) {
            return true
        }
        grid[r][c] = 0
    }
    return false
}

func neighbors(r, c int) (nbrs [][3]int) {
    for _, m := range moves {
        x := m[0]
        y := m[1]
        if grid[r+y][c+x] == 0 {
            num := countNeighbors(r+y, c+x) - 1
            nbrs = append(nbrs, [3]int{r + y, c + x, num})
        }
    }
    return
}

func countNeighbors(r, c int) int {
    num := 0
    for _, m := range moves {
        if grid[r+m[1]][c+m[0]] == 0 {
            num++
        }
    }
    return num
}

func printResult() {
    for _, row := range grid {
        for _, i := range row {
            if i == -1 {
                fmt.Print("   ")
            } else {
                fmt.Printf("%2d ", i)
            }
        }
        fmt.Println()
    }
}

func main() {
    nRows := len(board) + 6
    nCols := len(board[0]) + 6
    grid = make([][]int, nRows)
    for r := 0; r < nRows; r++ {
        grid[r] = make([]int, nCols)
        for c := 0; c < nCols; c++ {
            grid[r][c] = -1
        }
        for c := 3; c < nCols-3; c++ {
            if r >= 3 && r < nRows-3 {
                if board[r-3][c-3] == '0' {
                    grid[r][c] = 0
                    totalToFill++
                }
            }
        }
    }
    pos, r, c := -1, 0, 0
    for {
        for {
            pos++
            r = pos / nCols
            c = pos % nCols
            if grid[r][c] != -1 {
                break
            }
        }
        grid[r][c] = 1
        if solve(r, c, 2) {
            break
        }
        grid[r][c] = 0
        if pos >= nRows*nCols {
            break
        }
    }
    printResult()
}
