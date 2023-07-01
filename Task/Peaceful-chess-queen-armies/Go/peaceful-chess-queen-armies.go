package main

import "fmt"

const (
    empty = iota
    black
    white
)

const (
    bqueen  = 'B'
    wqueen  = 'W'
    bbullet = '•'
    wbullet = '◦'
)

type position struct{ i, j int }

func iabs(i int) int {
    if i < 0 {
        return -i
    }
    return i
}

func place(m, n int, pBlackQueens, pWhiteQueens *[]position) bool {
    if m == 0 {
        return true
    }
    placingBlack := true
    for i := 0; i < n; i++ {
    inner:
        for j := 0; j < n; j++ {
            pos := position{i, j}
            for _, queen := range *pBlackQueens {
                if queen == pos || !placingBlack && isAttacking(queen, pos) {
                    continue inner
                }
            }
            for _, queen := range *pWhiteQueens {
                if queen == pos || placingBlack && isAttacking(queen, pos) {
                    continue inner
                }
            }
            if placingBlack {
                *pBlackQueens = append(*pBlackQueens, pos)
                placingBlack = false
            } else {
                *pWhiteQueens = append(*pWhiteQueens, pos)
                if place(m-1, n, pBlackQueens, pWhiteQueens) {
                    return true
                }
                *pBlackQueens = (*pBlackQueens)[0 : len(*pBlackQueens)-1]
                *pWhiteQueens = (*pWhiteQueens)[0 : len(*pWhiteQueens)-1]
                placingBlack = true
            }
        }
    }
    if !placingBlack {
        *pBlackQueens = (*pBlackQueens)[0 : len(*pBlackQueens)-1]
    }
    return false
}

func isAttacking(queen, pos position) bool {
    if queen.i == pos.i {
        return true
    }
    if queen.j == pos.j {
        return true
    }
    if iabs(queen.i-pos.i) == iabs(queen.j-pos.j) {
        return true
    }
    return false
}

func printBoard(n int, blackQueens, whiteQueens []position) {
    board := make([]int, n*n)
    for _, queen := range blackQueens {
        board[queen.i*n+queen.j] = black
    }
    for _, queen := range whiteQueens {
        board[queen.i*n+queen.j] = white
    }

    for i, b := range board {
        if i != 0 && i%n == 0 {
            fmt.Println()
        }
        switch b {
        case black:
            fmt.Printf("%c ", bqueen)
        case white:
            fmt.Printf("%c ", wqueen)
        case empty:
            if i%2 == 0 {
                fmt.Printf("%c ", bbullet)
            } else {
                fmt.Printf("%c ", wbullet)
            }
        }
    }
    fmt.Println("\n")
}

func main() {
    nms := [][2]int{
        {2, 1}, {3, 1}, {3, 2}, {4, 1}, {4, 2}, {4, 3},
        {5, 1}, {5, 2}, {5, 3}, {5, 4}, {5, 5},
        {6, 1}, {6, 2}, {6, 3}, {6, 4}, {6, 5}, {6, 6},
        {7, 1}, {7, 2}, {7, 3}, {7, 4}, {7, 5}, {7, 6}, {7, 7},
    }
    for _, nm := range nms {
        n, m := nm[0], nm[1]
        fmt.Printf("%d black and %d white queens on a %d x %d board:\n", m, m, n, n)
        var blackQueens, whiteQueens []position
        if place(m, n, &blackQueens, &whiteQueens) {
            printBoard(n, blackQueens, whiteQueens)
        } else {
            fmt.Println("No solution exists.\n")
        }
    }
}
