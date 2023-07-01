package main

import "fmt"

const (
    start    = "_###_##_#_#_#_#__#__"
    offLeft  = '_'
    offRight = '_'
    dead     = '_'
)

func main() {
    fmt.Println(start)
    g := newGenerator(start, offLeft, offRight, dead)
    for i := 0; i < 10; i++ {
        fmt.Println(g())
    }
}

func newGenerator(start string, offLeft, offRight, dead byte) func() string {
    g0 := string(offLeft) + start + string(offRight)
    g1 := []byte(g0)
    last := len(g0) - 1
    return func() string {
        for i := 1; i < last; i++ {
            switch l := g0[i-1]; {
            case l != g0[i+1]:
                g1[i] = g0[i]
            case g0[i] == dead:
                g1[i] = l
            default:
                g1[i] = dead
            }
        }
        g0 = string(g1)
        return g0[1:last]
    }
}
