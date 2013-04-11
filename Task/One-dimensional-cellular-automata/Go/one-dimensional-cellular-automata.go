package main

import "fmt"

const start = "_###_##_#_#_#_#__#__"

func main() {
    g0 := []byte(start)
    g1 := []byte(start)
    fmt.Println(string(g0))
    last := len(g0) - 1
    for g := 0; g < 10; g++ {
        for i := 1; i < last; i++ {
            switch {
            case g0[i-1] != g0[i+1]:
                g1[i] = g0[i]
            case g0[i] == '_':
                g1[i] = g0[i-1]
            default:
                g1[i] = '_'
            }
        }
        fmt.Println(string(g1))
        copy(g0, g1)
    }
}
