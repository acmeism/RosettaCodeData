package main

import (
    "fmt"
    "math"
)

var testCases = []struct{ b1, b2 float64 }{
    {20, 45},
    {-45, 45},
    {-85, 90},
    {-95, 90},
    {-45, 125},
    {-45, 145},
    {29.4803, -88.6381},
    {-78.3251, -159.036},
    {-70099.74233810938, 29840.67437876723},
    {-165313.6666297357, 33693.9894517456},
    {1174.8380510598456, -154146.66490124757},
    {60175.77306795546, 42213.07192354373},
}

func main() {
    for _, tc := range testCases {
        fmt.Println(angleDifference(tc.b2, tc.b1))
    }
}

func angleDifference(b2, b1 float64) float64 {
    return math.Mod(math.Mod(b2-b1, 360)+360+180, 360) - 180
}
