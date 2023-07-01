package main

import (
    "fmt"
    "math"
)

func main() {
    const s = "1223334444"

    l := float64(0)
    m := map[rune]float64{}
    for _, r := range s {
        m[r]++
        l++
    }
    var hm float64
    for _, c := range m {
        hm += c * math.Log2(c)
    }
    fmt.Println(math.Log2(l) - hm/l)
}
