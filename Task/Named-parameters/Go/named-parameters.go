package main

import (
   "fmt"
)

type params struct {x, y, z int}

func myFunc(p params) int {
    return p.x + p.y + p.z
}

func main() {
    r := myFunc(params{x: 1, y: 2, z: 3}) // all fields, same order
    fmt.Println("r =", r)
    s := myFunc(params{z: 3, y: 2, x: 1}) // all fields, different order
    fmt.Println("s =", s)
    t := myFunc(params{y: 2})             // only one field, others set to zero
    fmt.Println("t =", t)
}
