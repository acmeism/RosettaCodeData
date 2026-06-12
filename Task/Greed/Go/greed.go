package main

import (
    "fmt"
    "github.com/nsf/termbox-go"
    "log"
    "math/rand"
    "strconv"
    "time"
)

type coord struct{ x, y int }

const (
    width  = 79
    height = 22
    nCount = float64(width * height)
)

var (
    board  [width * height]int
    score  = 0
    bold   = termbox.AttrBold
    cursor coord
)

var colors = [10]termbox.Attribute{
    termbox.ColorDefault,
    termbox.ColorWhite,
    termbox.ColorBlack | bold,
    termbox.ColorBlue | bold,
    termbox.ColorGreen | bold,
    termbox.ColorCyan | bold,
    termbox.ColorRed | bold,
    termbox.ColorMagenta | bold,
    termbox.ColorYellow | bold,
    termbox.ColorWhite | bold,
}

func printAt(x, y int, s string, fg, bg termbox.Attribute) {
    for _, r := range s {
        termbox.SetCell(x, y, r, fg, bg)
        x++
    }
}

func createBoard() {
    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            board[x+width*y] = rand.Intn(9) + 1
        }
    }
    cursor = coord{rand.Intn(width), rand.Intn(height)}
    board[cursor.x+width*cursor.y] = 0
    score = 0
    printScore()
}

func displayBoard() {
    termbox.SetCursor(0, 0)
    bg := colors[0]
    for y := 0; y < height; y++ {
        for x := 0; x < width; x++ {
            i := board[x+width*y]
            fg := colors[i]
            s := " "
            if i > 0 {
                s = strconv.Itoa(i)
            }
            printAt(x, y, s, fg, bg)
        }
    }
    fg := colors[9]
    termbox.SetCursor(cursor.x, cursor.y)
    printAt(cursor.x, cursor.y, "@", fg, bg)
    termbox.Flush()
}

func printScore() {
    termbox.SetCursor(0, 24)
    fg := colors[4]
    bg := termbox.ColorGreen
    s := fmt.Sprintf("      SCORE: %d : %.3f%%      ", score, float64(score)*100.0/nCount)
    printAt(0, 24, s, fg, bg)
    termbox.Flush()
}

func execute(x, y int) {
    i := board[cursor.x+x+width*(cursor.y+y)]
    if countSteps(i, x, y) {
        score += i
        for i != 0 {
            i--
            cursor.x += x
            cursor.y += y
            board[cursor.x+width*cursor.y] = 0
        }
    }
}

func countSteps(i, x, y int) bool {
    t := cursor
    for i != 0 {
        i--
        t.x += x
        t.y += y
        if t.x < 0 || t.y < 0 || t.x >= width || t.y >= height || board[t.x+width*t.y] == 0 {
            return false
        }
    }
    return true
}

func existsMoves() bool {
    for y := -1; y < 2; y++ {
        for x := -1; x < 2; x++ {
            if x == 0 && y == 0 {
                continue
            }
            ix := cursor.x + x + width*(cursor.y+y)
            i := 0
            if ix >= 0 && ix < len(board) {
                i = board[ix]
            }
            if i > 0 && countSteps(i, x, y) {
                return true
            }
        }
    }
    return false
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    err := termbox.Init()
    check(err)
    defer termbox.Close()

    eventQueue := make(chan termbox.Event)
    go func() {
        for {
            eventQueue <- termbox.PollEvent()
        }
    }()

    for {
        termbox.HideCursor()
        createBoard()
        for {
            displayBoard()
            select {
            case ev := <-eventQueue:
                if ev.Type == termbox.EventKey {
                    switch ev.Ch {
                    case 'q', 'Q':
                        if cursor.x > 0 && cursor.y > 0 {
                            execute(-1, -1)
                        }
                    case 'w', 'W':
                        if cursor.y > 0 {
                            execute(0, -1)
                        }
                    case 'e', 'E':
                        if cursor.x < width-1 && cursor.y > 0 {
                            execute(1, -1)
                        }
                    case 'a', 'A':
                        if cursor.x > 0 {
                            execute(-1, 0)
                        }
                    case 'd', 'D':
                        if cursor.x < width-1 {
                            execute(1, 0)
                        }
                    case 'z', 'Z':
                        if cursor.x > 0 && cursor.y < height-1 {
                            execute(-1, 1)
                        }
                    case 'x', 'X':
                        if cursor.y < height-1 {
                            execute(0, 1)
                        }
                    case 'c', 'C':
                        if cursor.x < width-1 && cursor.y < height-1 {
                            execute(1, 1)
                        }
                    case 'l', 'L': // leave key
                        return
                    }
                } else if ev.Type == termbox.EventResize {
                    termbox.Flush()
                }
            }
            printScore()
            if !existsMoves() {
                break
            }
        }
        displayBoard()
        fg := colors[7]
        bg := colors[0]
        printAt(19, 8, "+----------------------------------------+", fg, bg)
        printAt(19, 9, "|               GAME OVER                |", fg, bg)
        printAt(19, 10, "|            PLAY AGAIN(Y/N)?            |", fg, bg)
        printAt(19, 11, "+----------------------------------------+", fg, bg)
        termbox.SetCursor(48, 10)
        termbox.Flush()
        select {
        case ev := <-eventQueue:
            if ev.Type == termbox.EventKey {
                if ev.Ch == 'y' || ev.Ch == 'Y' {
                    break
                } else {
                    return
                }
            }
        }
    }
}
