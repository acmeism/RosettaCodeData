package main

import (
    "fmt"
    "math/rand"
    "strconv"
    "strings"
    "time"
)

var grid [8][8]byte

func abs(i int) int {
    if i >= 0 {
        return i
    } else {
        return -i
    }
}

func createFen() string {
    placeKings()
    placePieces("PPPPPPPP", true)
    placePieces("pppppppp", true)
    placePieces("RNBQBNR", false)
    placePieces("rnbqbnr", false)
    return toFen()
}

func placeKings() {
    for {
        r1 := rand.Intn(8)
        c1 := rand.Intn(8)
        r2 := rand.Intn(8)
        c2 := rand.Intn(8)
        if r1 != r2 && abs(r1-r2) > 1 && abs(c1-c2) > 1 {
            grid[r1][c1] = 'K'
            grid[r2][c2] = 'k'
            return
        }
    }
}

func placePieces(pieces string, isPawn bool) {
    numToPlace := rand.Intn(len(pieces))
    for n := 0; n < numToPlace; n++ {
        var r, c int
        for {
            r = rand.Intn(8)
            c = rand.Intn(8)
            if grid[r][c] == '\000' && !(isPawn && (r == 7 || r == 0)) {
                break
            }
        }
        grid[r][c] = pieces[n]
    }
}

func toFen() string {
    var fen strings.Builder
    countEmpty := 0
    for r := 0; r < 8; r++ {
        for c := 0; c < 8; c++ {
            ch := grid[r][c]
            if ch == '\000' {
                ch = '.'
            }
            fmt.Printf("%2c ", ch)
            if ch == '.' {
                countEmpty++
            } else {
                if countEmpty > 0 {
                    fen.WriteString(strconv.Itoa(countEmpty))
                    countEmpty = 0
                }
                fen.WriteByte(ch)
            }
        }
        if countEmpty > 0 {
            fen.WriteString(strconv.Itoa(countEmpty))
            countEmpty = 0
        }
        fen.WriteString("/")
        fmt.Println()
    }
    fen.WriteString(" w - - 0 1")
    return fen.String()
}

func main() {
    rand.Seed(time.Now().UnixNano())
    fmt.Println(createFen())
}
