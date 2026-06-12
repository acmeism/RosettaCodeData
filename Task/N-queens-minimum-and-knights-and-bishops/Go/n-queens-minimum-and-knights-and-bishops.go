package main

import (
    "fmt"
    "math"
    "strings"
    "time"
)

var board [][]bool
var diag1, diag2 [][]int
var diag1Lookup, diag2Lookup []bool
var n, minCount int
var layout string

func isAttacked(piece string, row, col int) bool {
    if piece == "Q" {
        for i := 0; i < n; i++ {
            if board[i][col] || board[row][i] {
                return true
            }
        }
        if diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]] {
            return true
        }
    } else if piece == "B" {
        if diag1Lookup[diag1[row][col]] || diag2Lookup[diag2[row][col]] {
            return true
        }
    } else { // piece == "K"
        if board[row][col] {
            return true
        }
        if row+2 < n && col-1 >= 0 && board[row+2][col-1] {
            return true
        }
        if row-2 >= 0 && col-1 >= 0 && board[row-2][col-1] {
            return true
        }
        if row+2 < n && col+1 < n && board[row+2][col+1] {
            return true
        }
        if row-2 >= 0 && col+1 < n && board[row-2][col+1] {
            return true
        }
        if row+1 < n && col+2 < n && board[row+1][col+2] {
            return true
        }
        if row-1 >= 0 && col+2 < n && board[row-1][col+2] {
            return true
        }
        if row+1 < n && col-2 >= 0 && board[row+1][col-2] {
            return true
        }
        if row-1 >= 0 && col-2 >= 0 && board[row-1][col-2] {
            return true
        }
    }
    return false
}

func abs(i int) int {
    if i < 0 {
        i = -i
    }
    return i
}

func attacks(piece string, row, col, trow, tcol int) bool {
    if piece == "Q" {
        return row == trow || col == tcol || abs(row-trow) == abs(col-tcol)
    } else if piece == "B" {
        return abs(row-trow) == abs(col-tcol)
    } else { // piece == "K"
        rd := abs(trow - row)
        cd := abs(tcol - col)
        return (rd == 1 && cd == 2) || (rd == 2 && cd == 1)
    }
}

func storeLayout(piece string) {
    var sb strings.Builder
    for _, row := range board {
        for _, cell := range row {
            if cell {
                sb.WriteString(piece + " ")
            } else {
                sb.WriteString(". ")
            }
        }
        sb.WriteString("\n")
    }
    layout = sb.String()
}

func placePiece(piece string, countSoFar, maxCount int) {
    if countSoFar >= minCount {
        return
    }
    allAttacked := true
    ti := 0
    tj := 0
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            if !isAttacked(piece, i, j) {
                allAttacked = false
                ti = i
                tj = j
                break
            }
        }
        if !allAttacked {
            break
        }
    }
    if allAttacked {
        minCount = countSoFar
        storeLayout(piece)
        return
    }
    if countSoFar <= maxCount {
        si := ti
        sj := tj
        if piece == "K" {
            si = si - 2
            sj = sj - 2
            if si < 0 {
                si = 0
            }
            if sj < 0 {
                sj = 0
            }
        }
        for i := si; i < n; i++ {
            for j := sj; j < n; j++ {
                if !isAttacked(piece, i, j) {
                    if (i == ti && j == tj) || attacks(piece, i, j, ti, tj) {
                        board[i][j] = true
                        if piece != "K" {
                            diag1Lookup[diag1[i][j]] = true
                            diag2Lookup[diag2[i][j]] = true
                        }
                        placePiece(piece, countSoFar+1, maxCount)
                        board[i][j] = false
                        if piece != "K" {
                            diag1Lookup[diag1[i][j]] = false
                            diag2Lookup[diag2[i][j]] = false
                        }
                    }
                }
            }
        }
    }
}

func main() {
    start := time.Now()
    pieces := []string{"Q", "B", "K"}
    limits := map[string]int{"Q": 10, "B": 10, "K": 10}
    names := map[string]string{"Q": "Queens", "B": "Bishops", "K": "Knights"}
    for _, piece := range pieces {
        fmt.Println(names[piece])
        fmt.Println("=======\n")

        for n = 1; ; n++ {
            board = make([][]bool, n)
            for i := 0; i < n; i++ {
                board[i] = make([]bool, n)
            }
            if piece != "K" {
                diag1 = make([][]int, n)
                for i := 0; i < n; i++ {
                    diag1[i] = make([]int, n)
                    for j := 0; j < n; j++ {
                        diag1[i][j] = i + j
                    }
                }
                diag2 = make([][]int, n)
                for i := 0; i < n; i++ {
                    diag2[i] = make([]int, n)
                    for j := 0; j < n; j++ {
                        diag2[i][j] = i - j + n - 1
                    }
                }
                diag1Lookup = make([]bool, 2*n-1)
                diag2Lookup = make([]bool, 2*n-1)
            }
            minCount = math.MaxInt32
            layout = ""
            for maxCount := 1; maxCount <= n*n; maxCount++ {
                placePiece(piece, 0, maxCount)
                if minCount <= n*n {
                    break
                }
            }
            fmt.Printf("%2d x %-2d : %d\n", n, n, minCount)
            if n == limits[piece] {
                fmt.Printf("\n%s on a %d x %d board:\n", names[piece], n, n)
                fmt.Println("\n" + layout)
                break
            }
        }
    }
    elapsed := time.Now().Sub(start)
    fmt.Printf("Took %s\n", elapsed)
}
