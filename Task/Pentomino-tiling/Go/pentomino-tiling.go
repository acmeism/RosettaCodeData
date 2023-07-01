package main

import (
    "fmt"
    "math/rand"
    "time"
)

var F = [][]int{
    {1, -1, 1, 0, 1, 1, 2, 1}, {0, 1, 1, -1, 1, 0, 2, 0},
    {1, 0, 1, 1, 1, 2, 2, 1}, {1, 0, 1, 1, 2, -1, 2, 0},
    {1, -2, 1, -1, 1, 0, 2, -1}, {0, 1, 1, 1, 1, 2, 2, 1},
    {1, -1, 1, 0, 1, 1, 2, -1}, {1, -1, 1, 0, 2, 0, 2, 1},
}

var I = [][]int{{0, 1, 0, 2, 0, 3, 0, 4}, {1, 0, 2, 0, 3, 0, 4, 0}}

var L = [][]int{
    {1, 0, 1, 1, 1, 2, 1, 3}, {1, 0, 2, 0, 3, -1, 3, 0},
    {0, 1, 0, 2, 0, 3, 1, 3}, {0, 1, 1, 0, 2, 0, 3, 0}, {0, 1, 1, 1, 2, 1, 3, 1},
    {0, 1, 0, 2, 0, 3, 1, 0}, {1, 0, 2, 0, 3, 0, 3, 1}, {1, -3, 1, -2, 1, -1, 1, 0},
}

var N = [][]int{
    {0, 1, 1, -2, 1, -1, 1, 0}, {1, 0, 1, 1, 2, 1, 3, 1},
    {0, 1, 0, 2, 1, -1, 1, 0}, {1, 0, 2, 0, 2, 1, 3, 1}, {0, 1, 1, 1, 1, 2, 1, 3},
    {1, 0, 2, -1, 2, 0, 3, -1}, {0, 1, 0, 2, 1, 2, 1, 3}, {1, -1, 1, 0, 2, -1, 3, -1},
}

var P = [][]int{
    {0, 1, 1, 0, 1, 1, 2, 1}, {0, 1, 0, 2, 1, 0, 1, 1},
    {1, 0, 1, 1, 2, 0, 2, 1}, {0, 1, 1, -1, 1, 0, 1, 1}, {0, 1, 1, 0, 1, 1, 1, 2},
    {1, -1, 1, 0, 2, -1, 2, 0}, {0, 1, 0, 2, 1, 1, 1, 2}, {0, 1, 1, 0, 1, 1, 2, 0},
}

var T = [][]int{
    {0, 1, 0, 2, 1, 1, 2, 1}, {1, -2, 1, -1, 1, 0, 2, 0},
    {1, 0, 2, -1, 2, 0, 2, 1}, {1, 0, 1, 1, 1, 2, 2, 0},
}

var U = [][]int{
    {0, 1, 0, 2, 1, 0, 1, 2}, {0, 1, 1, 1, 2, 0, 2, 1},
    {0, 2, 1, 0, 1, 1, 1, 2}, {0, 1, 1, 0, 2, 0, 2, 1},
}

var V = [][]int{
    {1, 0, 2, 0, 2, 1, 2, 2}, {0, 1, 0, 2, 1, 0, 2, 0},
    {1, 0, 2, -2, 2, -1, 2, 0}, {0, 1, 0, 2, 1, 2, 2, 2},
}

var W = [][]int{
    {1, 0, 1, 1, 2, 1, 2, 2}, {1, -1, 1, 0, 2, -2, 2, -1},
    {0, 1, 1, 1, 1, 2, 2, 2}, {0, 1, 1, -1, 1, 0, 2, -1},
}

var X = [][]int{{1, -1, 1, 0, 1, 1, 2, 0}}

var Y = [][]int{
    {1, -2, 1, -1, 1, 0, 1, 1}, {1, -1, 1, 0, 2, 0, 3, 0},
    {0, 1, 0, 2, 0, 3, 1, 1}, {1, 0, 2, 0, 2, 1, 3, 0}, {0, 1, 0, 2, 0, 3, 1, 2},
    {1, 0, 1, 1, 2, 0, 3, 0}, {1, -1, 1, 0, 1, 1, 1, 2}, {1, 0, 2, -1, 2, 0, 3, 0},
}

var Z = [][]int{
    {0, 1, 1, 0, 2, -1, 2, 0}, {1, 0, 1, 1, 1, 2, 2, 2},
    {0, 1, 1, 1, 2, 1, 2, 2}, {1, -2, 1, -1, 1, 0, 2, -2},
}

var shapes = [][][]int{F, I, L, N, P, T, U, V, W, X, Y, Z}

var symbols = []byte("FILNPTUVWXYZ-")

const (
    nRows = 8
    nCols = 8
    blank = 12
)

var grid [nRows][nCols]int
var placed [12]bool

func tryPlaceOrientation(o []int, r, c, shapeIndex int) bool {
    for i := 0; i < len(o); i += 2 {
        x := c + o[i+1]
        y := r + o[i]
        if x < 0 || x >= nCols || y < 0 || y >= nRows || grid[y][x] != -1 {
            return false
        }
    }
    grid[r][c] = shapeIndex
    for i := 0; i < len(o); i += 2 {
        grid[r+o[i]][c+o[i+1]] = shapeIndex
    }
    return true
}

func removeOrientation(o []int, r, c int) {
    grid[r][c] = -1
    for i := 0; i < len(o); i += 2 {
        grid[r+o[i]][c+o[i+1]] = -1
    }
}

func solve(pos, numPlaced int) bool {
    if numPlaced == len(shapes) {
        return true
    }
    row := pos / nCols
    col := pos % nCols
    if grid[row][col] != -1 {
        return solve(pos+1, numPlaced)
    }

    for i := range shapes {
        if !placed[i] {
            for _, orientation := range shapes[i] {
                if !tryPlaceOrientation(orientation, row, col, i) {
                    continue
                }
                placed[i] = true
                if solve(pos+1, numPlaced+1) {
                    return true
                }
                removeOrientation(orientation, row, col)
                placed[i] = false
            }
        }
    }
    return false
}

func shuffleShapes() {
    rand.Shuffle(len(shapes), func(i, j int) {
        shapes[i], shapes[j] = shapes[j], shapes[i]
        symbols[i], symbols[j] = symbols[j], symbols[i]
    })
}

func printResult() {
    for _, r := range grid {
        for _, i := range r {
            fmt.Printf("%c ", symbols[i])
        }
        fmt.Println()
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    shuffleShapes()
    for r := 0; r < nRows; r++ {
        for i := range grid[r] {
            grid[r][i] = -1
        }
    }
    for i := 0; i < 4; i++ {
        var randRow, randCol int
        for {
            randRow = rand.Intn(nRows)
            randCol = rand.Intn(nCols)
            if grid[randRow][randCol] != blank {
                break
            }
        }
        grid[randRow][randCol] = blank
    }
    if solve(0, 0) {
        printResult()
    } else {
        fmt.Println("No solution")
    }
}
