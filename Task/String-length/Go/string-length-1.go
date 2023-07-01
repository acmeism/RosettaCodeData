package main

import "fmt"

func main() {
    m := "møøse"
    u := "𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
    j := "J̲o̲s̲é̲"
    fmt.Printf("%d %s % x\n", len(m), m, m)
    fmt.Printf("%d %s % x\n", len(u), u, u)
    fmt.Printf("%d %s % x\n", len(j), j, j)
}
