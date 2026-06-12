package main

import (
    "fmt"
    "math"
)

func arcLength(radius, angle1, angle2 float64) float64 {
    return (360 - math.Abs(angle2-angle1)) * math.Pi * radius / 180
}

func main() {
    fmt.Println(arcLength(10, 10, 120))
}
