package main

import (
    "fmt"
    "runtime"
)

type point struct {
    x, y float64
}

func add(x, y int) int {
    result := x + y
    debug("x", x)
    debug("y", y)
    debug("result", result)
    debug("result+1", result+1)
    return result
}

func debug(s string, x interface{}) {
    _, _, lineNo, _ := runtime.Caller(1)
    fmt.Printf("%q at line %d type '%T'\nvalue: %#v\n\n", s, lineNo, x, x)
}

func main() {
    add(2, 7)
    b := true
    debug("b", b)
    s := "Hello"
    debug("s", s)
    p := point{2, 3}
    debug("p", p)
    q := &p
    debug("q", q)
}
