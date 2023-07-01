package main

import (
    "fmt"
    "math/rand"
    "time"
)

// input, 0-based start position
const startRow = 0
const startCol = 0

func main() {
    rand.Seed(time.Now().Unix())
    for !knightTour() {
    }
}

var moves = []struct{ dr, dc int }{
    {2, 1},
    {2, -1},
    {1, 2},
    {1, -2},
    {-1, 2},
    {-1, -2},
    {-2, 1},
    {-2, -1},
}

// Attempt knight tour starting at startRow, startCol using Warnsdorff's rule
// and random tie breaking.  If a tour is found, print it and return true.
// Otherwise no backtracking, just return false.
func knightTour() bool {
    // 8x8 board.  squares hold 1-based visit order.  0 means unvisited.
    board := make([][]int, 8)
    for i := range board {
        board[i] = make([]int, 8)
    }
    r := startRow
    c := startCol
    board[r][c] = 1 // first move
    for move := 2; move <= 64; move++ {
        minNext := 8
        var mr, mc, nm int
    candidateMoves:
        for _, cm := range moves {
            cr := r + cm.dr
            if cr < 0 || cr >= 8 { // off board
                continue
            }
            cc := c + cm.dc
            if cc < 0 || cc >= 8 { // off board
                continue
            }
            if board[cr][cc] > 0 { // already visited
                continue
            }
            // cr, cc candidate legal move.
            p := 0 // count possible next moves.
            for _, m2 := range moves {
                r2 := cr + m2.dr
                if r2 < 0 || r2 >= 8 {
                    continue
                }
                c2 := cc + m2.dc
                if c2 < 0 || c2 >= 8 {
                    continue
                }
                if board[r2][c2] > 0 {
                    continue
                }
                p++
                if p > minNext { // bail out as soon as it's eliminated
                    continue candidateMoves
                }
            }
            if p < minNext { // it's better.  keep it.
                minNext = p // new min possible next moves
                nm = 1      // number of candidates with this p
                mr = cr     // best candidate move
                mc = cc
                continue
            }
            // it ties for best so far.
            // keep it with probability 1/(number of tying moves)
            nm++                    // number of tying moves
            if rand.Intn(nm) == 0 { // one chance to keep it
                mr = cr
                mc = cc
            }
        }
        if nm == 0 { // no legal move
            return false
        }
        // make selected move
        r = mr
        c = mc
        board[r][c] = move
    }
    // tour complete.  print board.
    for _, r := range board {
        for _, m := range r {
            fmt.Printf("%3d", m)
        }
        fmt.Println()
    }
    return true
}
