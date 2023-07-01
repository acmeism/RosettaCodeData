package main

import "fmt"

const (
    width = 81
    height = 5
)

var lines [height][width]byte

func init() {
    for i := 0; i < height; i++ {
        for j := 0; j < width; j++ {
            lines[i][j] = '*'
        }
    }
}

func cantor(start, len, index int) {
    seg := len / 3
    if seg == 0 {
        return
    }
    for i := index; i < height; i++ {
        for j := start + seg; j < start + 2 * seg; j++ {
            lines[i][j] = ' '
        }
    }
    cantor(start, seg, index + 1)
    cantor(start + seg * 2, seg, index + 1)
}

func main() {
    cantor(0, width, 1)
    for _, line := range lines {
        fmt.Println(string(line[:]))
    }
}
