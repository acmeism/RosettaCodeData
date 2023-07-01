package main

import "fmt"

func pernicious(w uint32) bool {
    const (
        ff    = 1<<32 - 1
        mask1 = ff / 3
        mask3 = ff / 5
        maskf = ff / 17
        maskp = ff / 255
    )
    w -= w >> 1 & mask1
    w = w&mask3 + w>>2&mask3
    w = (w + w>>4) & maskf
    return 0xa08a28ac>>(w*maskp>>24)&1 != 0
}

func main() {
    for i, n := 0, uint32(1); i < 25; n++ {
        if pernicious(n) {
            fmt.Printf("%d ", n)
            i++
        }
    }
    fmt.Println()
    for n := uint32(888888877); n <= 888888888; n++ {
        if pernicious(n) {
            fmt.Printf("%d ", n)
        }
    }
    fmt.Println()
}
