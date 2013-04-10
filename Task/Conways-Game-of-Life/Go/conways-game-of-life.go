package main

import "fmt"

const (
    rows  = 3
    cols  = 3
    empty = '·' // middle dot
    alive = '*'
    start = "···***···"
    sz    = (rows + 2) * (cols + 2)
)

var (
    cs = make([]rune, sz)
    ns = make([]int, sz)
    nb [8]int
)

func main() {
    // initialize empty (really we just need the border)
    for i := range cs {
        cs[i] = empty
    }
    // initialize start
    si := []rune(start)
    for row := 1; row <= rows; row++ {
        for col := 1; col <= cols; col++ {
            cs[row*(cols+2)+col] = si[(row-1)*cols+col-1]
        }
    }
    // initialize neighbor offsets
    for i := 0; i < 3; i++ {
        nb[i] = i - cols - 3
        nb[i+3] = i + cols + 1
    }
    nb[6] = -1
    nb[7] = 1
    // run
    printU()
    for g := 0; g < 3; g++ {
        genU()
        printU()
    }
}

func genU() {
    // compute n
    for row := 1; row <= rows; row++ {
        for col := 1; col <= cols; col++ {
            cx := row*(cols+2) + col
            n := 0
            for _, d := range nb {
                if cs[cx+d] == '*' {
                    n++
                }
            }
            ns[cx] = n
        }
    }
    // update c
    for row := 1; row <= rows; row++ {
        for col := 1; col <= cols; col++ {
            cx := row*(cols+2) + col
            if cs[cx] == '*' {
                switch ns[cx] {
                case 0, 1, 4, 5, 6, 7, 8:
                    cs[cx] = '·'
                }
            } else if ns[cx] == 3 {
                cs[cx] = '*'
            }
        }
    }
}

func printU() {
    fmt.Println("")
    for row := 1; row <= rows; row++ {
        cx := row*(cols+2) + 1
        fmt.Println(string(cs[cx : cx+cols]))
    }
}
