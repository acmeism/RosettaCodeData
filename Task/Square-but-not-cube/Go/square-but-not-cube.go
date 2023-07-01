package main

import (
    "fmt"
    "math"
)

func main() {
    for n, count := 1, 0; count < 30; n++ {
        sq := n * n
        cr := int(math.Cbrt(float64(sq)))
        if cr*cr*cr != sq {
            count++
            fmt.Println(sq)
        } else {
            fmt.Println(sq, "is square and cube")
        }
    }
}
