package main

import "fmt"

var moves = [][2]int{
    {-1, -2}, {1, -2}, {-1, 2}, {1, 2}, {-2, -1}, {-2, 1}, {2, -1}, {2, 1},
}

var board1 = " xxx    " +
    " x xx   " +
    " xxxxxxx" +
    "xxx  x x" +
    "x x  xxx" +
    "sxxxxxx " +
    "  xx x  " +
    "   xxx  "

var board2 = ".....s.x....." +
    ".....x.x....." +
    "....xxxxx...." +
    ".....xxx....." +
    "..x..x.x..x.." +
    "xxxxx...xxxxx" +
    "..xx.....xx.." +
    "xxxxx...xxxxx" +
    "..x..x.x..x.." +
    ".....xxx....." +
    "....xxxxx...." +
    ".....x.x....." +
    ".....x.x....."

func solve(pz [][]int, sz, sx, sy, idx, cnt int) bool {
    if idx > cnt {
        return true
    }
    for i := 0; i < len(moves); i++ {
        x := sx + moves[i][0]
        y := sy + moves[i][1]
        if (x >= 0 && x < sz) && (y >= 0 && y < sz) && pz[x][y] == 0 {
            pz[x][y] = idx
            if solve(pz, sz, x, y, idx+1, cnt) {
                return true
            }
            pz[x][y] = 0
        }
    }
    return false
}

func findSolution(b string, sz int) {
    pz := make([][]int, sz)
    for i := 0; i < sz; i++ {
        pz[i] = make([]int, sz)
        for j := 0; j < sz; j++ {
            pz[i][j] = -1
        }
    }
    var x, y, idx, cnt int
    for j := 0; j < sz; j++ {
        for i := 0; i < sz; i++ {
            switch b[idx] {
            case 'x':
                pz[i][j] = 0
                cnt++
            case 's':
                pz[i][j] = 1
                cnt++
                x, y = i, j
            }
            idx++
        }
    }

    if solve(pz, sz, x, y, 2, cnt) {
        for j := 0; j < sz; j++ {
            for i := 0; i < sz; i++ {
                if pz[i][j] != -1 {
                    fmt.Printf("%02d  ", pz[i][j])
                } else {
                    fmt.Print("--  ")
                }
            }
            fmt.Println()
        }
    } else {
        fmt.Println("Cannot solve this puzzle!")
    }
}

func main() {
    findSolution(board1, 8)
    fmt.Println()
    findSolution(board2, 13)
}
