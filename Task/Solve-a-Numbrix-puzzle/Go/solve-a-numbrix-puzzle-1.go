package main

import (
    "fmt"
    "sort"
    "strconv"
    "strings"
)

var example1 = []string{
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00",
}

var example2 = []string{
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00",
}

var moves = [][2]int{{1, 0}, {0, 1}, {-1, 0}, {0, -1}}

var (
    grid        [][]int
    clues       []int
    totalToFill = 0
)

func solve(r, c, count, nextClue int) bool {
    if count > totalToFill {
        return true
    }

    back := grid[r][c]

    if back != 0 && back != count {
        return false
    }

    if back == 0 && nextClue < len(clues) && clues[nextClue] == count {
        return false
    }

    if back == count {
        nextClue++
    }

    grid[r][c] = count
    for _, move := range moves {
        if solve(r+move[1], c+move[0], count+1, nextClue) {
            return true
        }
    }
    grid[r][c] = back
    return false
}

func printResult(n int) {
    fmt.Println("Solution for example", n, "\b:")
    for _, row := range grid {
        for _, i := range row {
            if i == -1 {
                continue
            }
            fmt.Printf("%2d ", i)
        }
        fmt.Println()
    }
}

func main() {
    for n, board := range [2][]string{example1, example2} {
        nRows := len(board) + 2
        nCols := len(strings.Split(board[0], ",")) + 2
        startRow, startCol := 0, 0
        grid = make([][]int, nRows)
        totalToFill = (nRows - 2) * (nCols - 2)
        var lst []int

        for r := 0; r < nRows; r++ {
            grid[r] = make([]int, nCols)
            for c := 0; c < nCols; c++ {
                grid[r][c] = -1
            }
            if r >= 1 && r < nRows-1 {
                row := strings.Split(board[r-1], ",")
                for c := 1; c < nCols-1; c++ {
                    val, _ := strconv.Atoi(row[c-1])
                    if val > 0 {
                        lst = append(lst, val)
                    }
                    if val == 1 {
                        startRow, startCol = r, c
                    }
                    grid[r][c] = val
                }
            }
        }

        sort.Ints(lst)
        clues = lst
        if solve(startRow, startCol, 1, 0) {
            printResult(n + 1)
        }
    }
}
