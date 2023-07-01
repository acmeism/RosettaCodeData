package main

import "fmt"

func pf(v float64) float64 {
    switch {
    case v < .06:
        return .10
    case v < .11:
        return .18
    case v < .16:
        return .26
    case v < .21:
        return .32
    case v < .26:
        return .38
    case v < .31:
        return .44
    case v < .36:
        return .50
    case v < .41:
        return .54
    case v < .46:
        return .58
    case v < .51:
        return .62
    case v < .56:
        return .66
    case v < .61:
        return .70
    case v < .66:
        return .74
    case v < .71:
        return .78
    case v < .76:
        return .82
    case v < .81:
        return .86
    case v < .86:
        return .90
    case v < .91:
        return .94
    case v < .96:
        return .98
    }
    return 1
}

func main() {
    tests := []float64{0.3793, 0.4425, 0.0746, 0.6918, 0.2993,
        0.5486, 0.7848, 0.9383, 0.2292, 0.9760}
    for _, v := range tests {
        fmt.Printf("%0.4f -> %0.2f\n", v, pf(v))
    }
}
