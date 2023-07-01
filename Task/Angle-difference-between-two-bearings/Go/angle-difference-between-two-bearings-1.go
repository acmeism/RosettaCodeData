package main

import "fmt"

type bearing float64

var testCases = []struct{ b1, b2 bearing }{
    {20, 45},
    {-45, 45},
    {-85, 90},
    {-95, 90},
    {-45, 125},
    {-45, 145},
    {29.4803, -88.6381},
    {-78.3251, -159.036},
}

func main() {
    for _, tc := range testCases {
        fmt.Println(tc.b2.Sub(tc.b1))
    }
}

func (b2 bearing) Sub(b1 bearing) bearing {
    switch d := b2 - b1; {
    case d < -180:
        return d + 360
    case d > 180:
        return d - 360
    default:
        return d
    }
}
