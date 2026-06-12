package main

import (
    gc "github.com/rthornton128/goncurses"
    "log"
    "math/rand"
    "time"
)

// optional settings
const (
    lineLen  = 5
    disjoint = 0
)

var (
    board  [][]int
    width  int
    height int
)

const (
    blank    = 0
    occupied = 1 << (iota - 1)
    dirNS
    dirEW
    dirNESW
    dirNWSE
    newlyAdded
    current
)

var ofs = [4][3]int{
    {0, 1, dirNS},
    {1, 0, dirEW},
    {1, -1, dirNESW},
    {1, 1, dirNWSE},
}

type move struct{ m, s, seq, x, y int }

func btoi(b bool) int {
    if b {
        return 1
    }
    return 0
}

func allocBoard(w, h int) [][]int {
    buf := make([][]int, h)
    for i := 0; i < h; i++ {
        buf[i] = make([]int, w)
    }
    return buf
}

func boardSet(v, x0, y0, x1, y1 int) {
    for i := y0; i <= y1; i++ {
        for j := x0; j <= x1; j++ {
            board[i][j] = v
        }
    }
}

func initBoard() {
    height = 3 * (lineLen - 1)
    width = height
    board = allocBoard(width, height)

    boardSet(occupied, lineLen-1, 1, 2*lineLen-3, height-2)
    boardSet(occupied, 1, lineLen-1, width-2, 2*lineLen-3)
    boardSet(blank, lineLen, 2, 2*lineLen-4, height-3)
    boardSet(blank, 2, lineLen, width-3, 2*lineLen-4)
}

// -1: expand low index end; 1: expand high index end
func expandBoard(dw, dh int) {
    dw2, dh2 := 1, 1
    if dw == 0 {
        dw2 = 0
    }
    if dh == 0 {
        dh2 = 0
    }
    nw, nh := width+dw2, height+dh2
    nbuf := allocBoard(nw, nh)
    dw, dh = -btoi(dw < 0), -btoi(dh < 0)
    for i := 0; i < nh; i++ {
        if i+dh < 0 || i+dh >= height {
            continue
        }
        for j := 0; j < nw; j++ {
            if j+dw < 0 || j+dw >= width {
                continue
            }
            nbuf[i][j] = board[i+dh][j+dw]
        }
    }
    board = nbuf
    width, height = nw, nh
}

func showBoard(scr *gc.Window) {
    for i := 0; i < height; i++ {
        for j := 0; j < width; j++ {
            var temp string
            switch {
            case (board[i][j] & current) != 0:
                temp = "X "
            case (board[i][j] & newlyAdded) != 0:
                temp = "0 "
            case (board[i][j] & occupied) != 0:
                temp = "+ "
            default:
                temp = "  "
            }
            scr.MovePrintf(i+1, j*2, temp)
        }
    }
    scr.Refresh()
}

// test if a point can complete a line, or take that point
func testPosition(y, x int, rec *move) {
    if (board[y][x] & occupied) != 0 {
        return
    }
    for m := 0; m < 4; m++ { // 4 directions
        dx := ofs[m][0]
        dy := ofs[m][1]
        dir := ofs[m][2]
        var k int
        for s := 1 - lineLen; s <= 0; s++ { // offset line
            for k = 0; k < lineLen; k++ {
                if s+k == 0 {
                    continue
                }
                xx := x + dx*(s+k)
                yy := y + dy*(s+k)
                if xx < 0 || xx >= width || yy < 0 || yy >= height {
                    break
                }

                // no piece at position
                if (board[yy][xx] & occupied) == 0 {
                    break
                }

                // this direction taken
                if (board[yy][xx] & dir) != 0 {
                    break
                }
            }
            if k != lineLen {
                continue
            }

            // position ok
            // rand.Intn to even each option's chance of being picked
            rec.seq++
            if rand.Intn(rec.seq) == 0 {
                rec.m, rec.s, rec.x, rec.y = m, s, x, y
            }
        }
    }
}

func addPiece(rec *move) {
    dx := ofs[rec.m][0]
    dy := ofs[rec.m][1]
    dir := ofs[rec.m][2]
    board[rec.y][rec.x] |= current | occupied
    for k := 0; k < lineLen; k++ {
        xx := rec.x + dx*(k+rec.s)
        yy := rec.y + dy*(k+rec.s)
        board[yy][xx] |= newlyAdded
        if k >= disjoint || k < lineLen-disjoint {
            board[yy][xx] |= dir
        }
    }
}

func nextMove() bool {
    var rec move
    // wipe last iteration's new line markers
    for i := 0; i < height; i++ {
        for j := 0; j < width; j++ {
            board[i][j] &^= newlyAdded | current
        }
    }

    // randomly pick one of next legal moves
    for i := 0; i < height; i++ {
        for j := 0; j < width; j++ {
            testPosition(i, j, &rec)
        }
    }

    // didn't find any move, game over
    if rec.seq == 0 {
        return false
    }

    addPiece(&rec)

    if rec.x == width-1 {
        rec.x = 1
    } else if rec.x != 0 {
        rec.x = 0
    } else {
        rec.x = -1
    }

    if rec.y == height-1 {
        rec.y = 1
    } else if rec.y != 0 {
        rec.y = 0
    } else {
        rec.y = -1
    }

    if rec.x != 0 || rec.y != 0 {
        expandBoard(rec.x, rec.y)
    }
    return true
}

func main() {
    rand.Seed(time.Now().UnixNano())
    initBoard()
    scr, err := gc.Init()
    if err != nil {
        log.Fatal("init", err)
    }
    defer gc.End()
    gc.Echo(false)
    gc.CBreak(true)
    ch := gc.Key(0)
    move := 0
    waitKey := true
    for {
        scr.MovePrintf(0, 0, "Move %d", move)
        move++
        showBoard(scr)
        if !nextMove() {
            nextMove()
            showBoard(scr)
            break
        }
        if !waitKey {
            time.Sleep(100000 * time.Microsecond)
        }
        if ch = scr.GetChar(); ch == ' ' {
            waitKey = !waitKey
            if waitKey {
                scr.Timeout(-1)
            } else {
                scr.Timeout(0)
            }
        }
        if ch == 'q' {
            break
        }
    }
    scr.Timeout(-1)
    gc.CBreak(false)
    gc.Echo(true)
}
