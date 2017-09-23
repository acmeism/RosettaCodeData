package main

import (
    "fmt"
    "math"
)

func main() {
    const s = "1223334444"

    m := map[rune]float64{}
    for _, r := range s {
        m[r]++
    }
    var fm float64
    for _, c := range m {
        hm += c * math.Log2(c)
    }
    const l = float64(len(s))
    fmt.Println(math.Log2(l) - hm/l)
}
