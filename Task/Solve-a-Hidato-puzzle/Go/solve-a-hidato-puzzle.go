package main

import (
    "fmt"
    "sort"
    "strconv"
    "strings"
)

var board [][]int
var start, given []int

func setup(input []string) {
    /* This task is not about input validation, so
       we're going to trust the input to be valid */
    puzzle := make([][]string, len(input))
    for i := 0; i < len(input); i++ {
        puzzle[i] = strings.Fields(input[i])
    }
    nCols := len(puzzle[0])
    nRows := len(puzzle)
    list := make([]int, nRows*nCols)
    board = make([][]int, nRows+2)
    for i := 0; i < nRows+2; i++ {
        board[i] = make([]int, nCols+2)
        for j := 0; j < nCols+2; j++ {
            board[i][j] = -1
        }
    }
    for r := 0; r < nRows; r++ {
        row := puzzle[r]
        for c := 0; c < nCols; c++ {
            switch cell := row[c]; cell {
            case "_":
                board[r+1][c+1] = 0
            case ".":
                break
            default:
                val, _ := strconv.Atoi(cell)
                board[r+1][c+1] = val
                list = append(list, val)
                if val == 1 {
                    start = append(start, r+1, c+1)
                }
            }
        }
    }
    sort.Ints(list)
    given = make([]int, len(list))
    for i := 0; i < len(given); i++ {
        given[i] = list[i]
    }
}

func solve(r, c, n, next int) bool {
    if n > given[len(given)-1] {
        return true
    }

    back := board[r][c]
    if back != 0 && back != n {
        return false
    }

    if back == 0 && given[next] == n {
        return false
    }

    if back == n {
        next++
    }

    board[r][c] = n
    for i := -1; i < 2; i++ {
        for j := -1; j < 2; j++ {
            if solve(r+i, c+j, n+1, next) {
                return true
            }
        }
    }

    board[r][c] = back
    return false
}

func printBoard() {
    for _, row := range board {
        for _, c := range row {
            switch {
            case c == -1:
                fmt.Print(" . ")
            case c > 0:
                fmt.Printf("%2d ", c)
            default:
                fmt.Print("__ ")
            }
        }
        fmt.Println()
    }
}

func main() {
    input := []string{
        "_ 33 35 _ _ . . .",
        "_ _ 24 22 _ . . .",
        "_ _ _ 21 _ _ . .",
        "_ 26 _ 13 40 11 . .",
        "27 _ _ _ 9 _ 1 .",
        ". . _ _ 18 _ _ .",
        ". . . . _ 7 _ _",
        ". . . . . . 5 _",
    }
    setup(input)
    printBoard()
    fmt.Println("\nFound:")
    solve(start[0], start[1], 1, 0)
    printBoard()
}
