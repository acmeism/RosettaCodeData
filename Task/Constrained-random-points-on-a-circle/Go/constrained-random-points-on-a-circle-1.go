package main

import (
    "bytes"
    "fmt"
    "math/rand"
    "time"
)

type pt struct {
    x, y int
}

func main() {
    rand.Seed(time.Now().UnixNano())
    // generate random points, accumulate 100 distinct points meeting condition
    m := make(map[int]pt) // key is buffer index
    for len(m) < 100 {
        p := pt{rand.Intn(31) - 15, rand.Intn(31) - 15}
        rs := p.x*p.x + p.y*p.y
        if 100 <= rs && rs <= 225 {
            m[(p.x+15)*2+(p.y+15)*31*2] = p
        }
    }
    // plot to buffer
    b := bytes.Repeat([]byte{' '}, 31*31*2)
    for i := range m {
        b[i] = '*'
    }
    // print buffer to screen
    for i := 0; i < 31; i++ {
        fmt.Println(string(b[i*31*2 : (i+1)*31*2]))
    }
}
