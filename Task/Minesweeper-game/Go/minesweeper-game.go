package main

import (
    "bufio"
    "fmt"
    "math"
    "math/rand"
    "os"
    "strconv"
    "strings"
    "time"
)

type cell struct {
    isMine  bool
    display byte // display character for cell
}

const lMargin = 4

var (
    grid        [][]cell
    mineCount   int
    minesMarked int
    isGameOver  bool
)

var scanner = bufio.NewScanner(os.Stdin)

func makeGrid(n, m int) {
    if n <= 0 || m <= 0 {
        panic("Grid dimensions must be positive.")
    }
    grid = make([][]cell, n)
    for i := 0; i < n; i++ {
        grid[i] = make([]cell, m)
        for j := 0; j < m; j++ {
            grid[i][j].display = '.'
        }
    }
    min := int(math.Round(float64(n*m) * 0.1)) // 10% of tiles
    max := int(math.Round(float64(n*m) * 0.2)) // 20% of tiles
    mineCount = min + rand.Intn(max-min+1)
    rm := mineCount
    for rm > 0 {
        x, y := rand.Intn(n), rand.Intn(m)
        if !grid[x][y].isMine {
            rm--
            grid[x][y].isMine = true
        }
    }
    minesMarked = 0
    isGameOver = false
}

func displayGrid(isEndOfGame bool) {
    if !isEndOfGame {
        fmt.Println("Grid has", mineCount, "mine(s),", minesMarked, "mine(s) marked.")
    }
    margin := strings.Repeat(" ", lMargin)
    fmt.Print(margin, " ")
    for i := 1; i <= len(grid); i++ {
        fmt.Print(i)
    }
    fmt.Println()
    fmt.Println(margin, strings.Repeat("-", len(grid)))
    for y := 0; y < len(grid[0]); y++ {
        fmt.Printf("%*d:", lMargin, y+1)
        for x := 0; x < len(grid); x++ {
            fmt.Printf("%c", grid[x][y].display)
        }
        fmt.Println()
    }
}

func endGame(msg string) {
    isGameOver = true
    fmt.Println(msg)
    ans := ""
    for ans != "y" && ans != "n" {
        fmt.Print("Another game (y/n)? : ")
        scanner.Scan()
        ans = strings.ToLower(scanner.Text())
    }
    if scanner.Err() != nil || ans == "n" {
        return
    }
    makeGrid(6, 4)
    displayGrid(false)
}

func resign() {
    found := 0
    for y := 0; y < len(grid[0]); y++ {
        for x := 0; x < len(grid); x++ {
            if grid[x][y].isMine {
                if grid[x][y].display == '?' {
                    grid[x][y].display = 'Y'
                    found++
                } else if grid[x][y].display != 'x' {
                    grid[x][y].display = 'N'
                }
            }
        }
    }
    displayGrid(true)
    msg := fmt.Sprint("You found ", found, " out of ", mineCount, " mine(s).")
    endGame(msg)
}

func usage() {
    fmt.Println("h or ? - this help,")
    fmt.Println("c x y  - clear cell (x,y),")
    fmt.Println("m x y  - marks (toggles) cell (x,y),")
    fmt.Println("n      - start a new game,")
    fmt.Println("q      - quit/resign the game,")
    fmt.Println("where x is the (horizontal) column number and y is the (vertical) row number.\n")
}

func markCell(x, y int) {
    if grid[x][y].display == '?' {
        minesMarked--
        grid[x][y].display = '.'
    } else if grid[x][y].display == '.' {
        minesMarked++
        grid[x][y].display = '?'
    }
}

func countAdjMines(x, y int) int {
    count := 0
    for j := y - 1; j <= y+1; j++ {
        if j >= 0 && j < len(grid[0]) {
            for i := x - 1; i <= x+1; i++ {
                if i >= 0 && i < len(grid) {
                    if grid[i][j].isMine {
                        count++
                    }
                }
            }
        }
    }
    return count
}

func clearCell(x, y int) bool {
    if x >= 0 && x < len(grid) && y >= 0 && y < len(grid[0]) {
        if grid[x][y].display == '.' {
            if !grid[x][y].isMine {
                count := countAdjMines(x, y)
                if count > 0 {
                    grid[x][y].display = string(48 + count)[0]
                } else {
                    grid[x][y].display = ' '
                    clearCell(x+1, y)
                    clearCell(x+1, y+1)
                    clearCell(x, y+1)
                    clearCell(x-1, y+1)
                    clearCell(x-1, y)
                    clearCell(x-1, y-1)
                    clearCell(x, y-1)
                    clearCell(x+1, y-1)
                }
            } else {
                grid[x][y].display = 'x'
                fmt.Println("Kaboom! You lost!")
                return false
            }
        }
    }
    return true
}

func testForWin() bool {
    isCleared := false
    if minesMarked == mineCount {
        isCleared = true
        for x := 0; x < len(grid); x++ {
            for y := 0; y < len(grid[0]); y++ {
                if grid[x][y].display == '.' {
                    isCleared = false
                }
            }
        }
    }
    if isCleared {
        fmt.Println("You won!")
    }
    return isCleared
}

func splitAction(action string) (int, int, bool) {
    fields := strings.Fields(action)
    if len(fields) != 3 {
        return 0, 0, false
    }
    x, err := strconv.Atoi(fields[1])
    if err != nil || x < 1 || x > len(grid) {
        return 0, 0, false
    }
    y, err := strconv.Atoi(fields[2])
    if err != nil || y < 1 || y > len(grid[0]) {
        return 0, 0, false
    }
    return x, y, true
}

func main() {
    rand.Seed(time.Now().UnixNano())
    usage()
    makeGrid(6, 4)
    displayGrid(false)
    for !isGameOver {
        fmt.Print("\n>")
        scanner.Scan()
        action := strings.ToLower(scanner.Text())
        if scanner.Err() != nil || len(action) == 0 {
            continue
        }
        switch action[0] {
        case 'h', '?':
            usage()
        case 'n':
            makeGrid(6, 4)
            displayGrid(false)
        case 'c':
            x, y, ok := splitAction(action)
            if !ok {
                continue
            }
            if clearCell(x-1, y-1) {
                displayGrid(false)
                if testForWin() {
                    resign()
                }
            } else {
                resign()
            }
        case 'm':
            x, y, ok := splitAction(action)
            if !ok {
                continue
            }
            markCell(x-1, y-1)
            displayGrid(false)
            if testForWin() {
                resign()
            }
        case 'q':
            resign()
        }
    }
}
