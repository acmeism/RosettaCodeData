package main

import (
    "fmt"
    "math"
)

type vector [3]float64
type matrix [3]vector

func norm(v vector) float64 {
    return math.Sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2])
}

func normalize(v vector) vector {
    length := norm(v)
    return vector{v[0] / length, v[1] / length, v[2] / length}
}

func dotProduct(v1, v2 vector) float64 {
    return v1[0]*v2[0] + v1[1]*v2[1] + v1[2]*v2[2]
}

func crossProduct(v1, v2 vector) vector {
    return vector{v1[1]*v2[2] - v1[2]*v2[1], v1[2]*v2[0] - v1[0]*v2[2], v1[0]*v2[1] - v1[1]*v2[0]}
}

func getAngle(v1, v2 vector) float64 {
    return math.Acos(dotProduct(v1, v2) / (norm(v1) * norm(v2)))
}

func matrixMultiply(m matrix, v vector) vector {
    return vector{dotProduct(m[0], v), dotProduct(m[1], v), dotProduct(m[2], v)}
}

func aRotate(p, v vector, a float64) vector {
    ca, sa := math.Cos(a), math.Sin(a)
    t := 1 - ca
    x, y, z := v[0], v[1], v[2]
    r := matrix{
        {ca + x*x*t, x*y*t - z*sa, x*z*t + y*sa},
        {x*y*t + z*sa, ca + y*y*t, y*z*t - x*sa},
        {z*x*t - y*sa, z*y*t + x*sa, ca + z*z*t},
    }
    return matrixMultiply(r, p)
}

func main() {
    v1 := vector{5, -6, 4}
    v2 := vector{8, 5, -30}
    a := getAngle(v1, v2)
    cp := crossProduct(v1, v2)
    ncp := normalize(cp)
    np := aRotate(v1, ncp, a)
    fmt.Println(np)
}
