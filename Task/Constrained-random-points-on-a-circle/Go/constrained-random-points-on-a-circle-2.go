package main

import (
    "bytes"
    "fmt"
    "math/rand"
)

type pt struct {
    x, y int
}

func main() {
    // generate possible points
    all := make([]pt, 0, 404)
    for x := -15; x <= 15; x++ {
        for y := -15; y <= 15; y++ {
            rs := x*x + y*y
            if 100 <= rs && rs <= 225 {
                all = append(all, pt{x, y})
            }
        }
    }
    if len(all) != 404 {
        panic(len(all))
    }
    // randomly order
    rp := rand.Perm(404)
    // plot 100 of them to a buffer
    b := bytes.Repeat([]byte{' '}, 31*31*2)
    for i := 0; i < 100; i++ {
        p := all[rp[i]]
        b[(p.x+15)*2+(p.y+15)*31*2] = '*'
    }
    // print buffer to screen
    for i := 0; i < 31; i++ {
        fmt.Println(string(b[i*31*2 : (i+1)*31*2]))
    }
}
