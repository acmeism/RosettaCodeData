package main

import (
    "fmt"
    "math"
)

func squareDiff(k int) int {
    return int(math.Ceil(float64(k+1) * 0.5))
}

func main() {
    fmt.Println(squareDiff(1000))
}
