package main

import (
    "bytes"
    "fmt"
    "strings"
)

var in = `
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000`

func main() {
    b := wbFromString(in, '1')
    b.zhangSuen()
    fmt.Println(b)
}

const (
    white = 0
    black = 1
)

type wbArray [][]byte // elements are white or black.

// parameter blk is character to read as black.  otherwise kinda rigid,
// expects ascii, leading newline, no trailing newline,
// takes color from low bit of character.
func wbFromString(s string, blk byte) wbArray {
    lines := strings.Split(s, "\n")[1:]
    b := make(wbArray, len(lines))
    for i, sl := range lines {
        bl := make([]byte, len(sl))
        for j := 0; j < len(sl); j++ {
            bl[j] = sl[j] & 1
        }
        b[i] = bl
    }
    return b
}

// rigid again, hard coded to output space for white, # for black,
// no leading or trailing newline.
var sym = [2]byte{
    white: ' ',
    black: '#',
}

func (b wbArray) String() string {
    b2 := bytes.Join(b, []byte{'\n'})
    for i, b1 := range b2 {
        if b1 > 1 {
            continue
        }
        b2[i] = sym[b1]
    }
    return string(b2)
}

// neighbor offsets
var nb = [...][2]int{
    2: {-1, 0}, // p2 offsets
    3: {-1, 1}, // ...
    4: {0, 1},
    5: {1, 1},
    6: {1, 0},
    7: {1, -1},
    8: {0, -1},
    9: {-1, -1}, // p9 offsets
}

func (b wbArray) reset(en []int) (rs bool) {
    var r, c int
    var p [10]byte

    readP := func() {
        for nx := 1; nx <= 9; nx++ {
            n := nb[nx]
            p[nx] = b[r+n[0]][c+n[1]]
        }
    }

    shiftRead := func() {
        n := nb[3]
        p[9], p[2], p[3] = p[2], p[3], b[r+n[0]][c+n[1]]
        n = nb[4]
        p[8], p[1], p[4] = p[1], p[4], b[r+n[0]][c+n[1]]
        n = nb[5]
        p[7], p[6], p[5] = p[6], p[5], b[r+n[0]][c+n[1]]
    }

    // returns "A", count of white->black transitions in circuit of neighbors
    // of an interior pixel b[r][c]
    countA := func() (ct byte) {
        bit := p[9]
        for nx := 2; nx <= 9; nx++ {
            last := bit
            bit = p[nx]
            if last == white {
                ct += bit
            }
        }
        return ct
    }

    // returns "B", count of black pixels neighboring interior pixel b[r][c].
    countB := func() (ct byte) {
        for nx := 2; nx <= 9; nx++ {
            ct += p[nx]
        }
        return ct
    }

    lastRow := len(b) - 1
    lastCol := len(b[0]) - 1

    mark := make([][]bool, lastRow)
    for r = range mark {
        mark[r] = make([]bool, lastCol)
    }

    for r = 1; r < lastRow; r++ {
        c = 1
        readP()
        for { // column loop
            m := false
            // test for failure of any of the five conditions,
            if !(p[1] == black) {
                goto markDone
            }
            if b1 := countB(); !(2 <= b1 && b1 <= 6) {
                goto markDone
            }
            if !(countA() == 1) {
                goto markDone
            }
            {
                e1, e2 := p[en[1]], p[en[2]]
                if !(p[en[0]]&e1&e2 == 0) {
                    goto markDone
                }
                if !(e1&e2&p[en[3]] == 0) {
                    goto markDone
                }
            }
            // no conditions failed, mark this pixel for reset
            m = true
            rs = true // and mark that image changes
        markDone:
            mark[r][c] = m
            c++
            if c == lastCol {
                break
            }
            shiftRead()
        }
    }
    if rs {
        for r = 1; r < lastRow; r++ {
            for c = 1; c < lastCol; c++ {
                if mark[r][c] {
                    b[r][c] = white
                }
            }
        }
    }
    return rs
}

var step1 = []int{2, 4, 6, 8}
var step2 = []int{4, 2, 8, 6}

func (b wbArray) zhangSuen() {
    for {
        rs1 := b.reset(step1)
        rs2 := b.reset(step2)
        if !rs1 && !rs2 {
            break
        }
    }
}
