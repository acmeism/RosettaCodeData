package main

import "fmt"

type solution struct{ peg, over, land int }

type move struct{ from, to int }

var emptyStart = 1

var board [16]bool

var jumpMoves = [16][]move{
    {},
    {{2, 4}, {3, 6}},
    {{4, 7}, {5, 9}},
    {{5, 8}, {6, 10}},
    {{2, 1}, {5, 6}, {7, 11}, {8, 13}},
    {{8, 12}, {9, 14}},
    {{3, 1}, {5, 4}, {9, 13}, {10, 15}},
    {{4, 2}, {8, 9}},
    {{5, 3}, {9, 10}},
    {{5, 2}, {8, 7}},
    {{9, 8}},
    {{12, 13}},
    {{8, 5}, {13, 14}},
    {{8, 4}, {9, 6}, {12, 11}, {14, 15}},
    {{9, 5}, {13, 12}},
    {{10, 6}, {14, 13}},
}

var solutions []solution

func initBoard() {
    for i := 1; i < 16; i++ {
        board[i] = true
    }
    board[emptyStart] = false
}

func (sol solution) split() (int, int, int) {
    return sol.peg, sol.over, sol.land
}

func (mv move) split() (int, int) {
    return mv.from, mv.to
}

func drawBoard() {
    var pegs [16]byte
    for i := 1; i < 16; i++ {
        if board[i] {
            pegs[i] = fmt.Sprintf("%X", i)[0]
        } else {
            pegs[i] = '-'
        }
    }
    fmt.Printf("       %c\n", pegs[1])
    fmt.Printf("      %c %c\n", pegs[2], pegs[3])
    fmt.Printf("     %c %c %c\n", pegs[4], pegs[5], pegs[6])
    fmt.Printf("    %c %c %c %c\n", pegs[7], pegs[8], pegs[9], pegs[10])
    fmt.Printf("   %c %c %c %c %c\n", pegs[11], pegs[12], pegs[13], pegs[14], pegs[15])
}

func solved() bool {
    count := 0
    for _, b := range board {
        if b {
            count++
        }
    }
    return count == 1 // just one peg left
}

func solve() {
    if solved() {
        return
    }
    for peg := 1; peg < 16; peg++ {
        if board[peg] {
            for _, mv := range jumpMoves[peg] {
                over, land := mv.split()
                if board[over] && !board[land] {
                    saveBoard := board
                    board[peg] = false
                    board[over] = false
                    board[land] = true
                    solutions = append(solutions, solution{peg, over, land})
                    solve()
                    if solved() {
                        return // otherwise back-track
                    }
                    board = saveBoard
                    solutions = solutions[:len(solutions)-1]
                }
            }
        }
    }
}

func main() {
    initBoard()
    solve()
    initBoard()
    drawBoard()
    fmt.Printf("Starting with peg %X removed\n\n", emptyStart)
    for _, solution := range solutions {
        peg, over, land := solution.split()
        board[peg] = false
        board[over] = false
        board[land] = true
        drawBoard()
        fmt.Printf("Peg %X jumped over %X to land on %X\n\n", peg, over, land)
    }
}
