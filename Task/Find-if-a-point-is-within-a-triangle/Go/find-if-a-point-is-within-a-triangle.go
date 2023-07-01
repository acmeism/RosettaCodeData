package main

import (
    "fmt"
    "math"
)

const EPS = 0.001
const EPS_SQUARE = EPS * EPS

func side(x1, y1, x2, y2, x, y float64) float64 {
    return (y2-y1)*(x-x1) + (-x2+x1)*(y-y1)
}

func naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y float64) bool {
    checkSide1 := side(x1, y1, x2, y2, x, y) >= 0
    checkSide2 := side(x2, y2, x3, y3, x, y) >= 0
    checkSide3 := side(x3, y3, x1, y1, x, y) >= 0
    return checkSide1 && checkSide2 && checkSide3
}

func pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y float64) bool {
    xMin := math.Min(x1, math.Min(x2, x3)) - EPS
    xMax := math.Max(x1, math.Max(x2, x3)) + EPS
    yMin := math.Min(y1, math.Min(y2, y3)) - EPS
    yMax := math.Max(y1, math.Max(y2, y3)) + EPS
    return !(x < xMin || xMax < x || y < yMin || yMax < y)
}

func distanceSquarePointToSegment(x1, y1, x2, y2, x, y float64) float64 {
    p1_p2_squareLength := (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1)
    dotProduct := ((x-x1)*(x2-x1) + (y-y1)*(y2-y1)) / p1_p2_squareLength
    if dotProduct < 0 {
        return (x-x1)*(x-x1) + (y-y1)*(y-y1)
    } else if dotProduct <= 1 {
        p_p1_squareLength := (x1-x)*(x1-x) + (y1-y)*(y1-y)
        return p_p1_squareLength - dotProduct*dotProduct*p1_p2_squareLength
    } else {
        return (x-x2)*(x-x2) + (y-y2)*(y-y2)
    }
}

func accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y float64) bool {
    if !pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y) {
        return false
    }
    if naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y) {
        return true
    }
    if distanceSquarePointToSegment(x1, y1, x2, y2, x, y) <= EPS_SQUARE {
        return true
    }
    if distanceSquarePointToSegment(x2, y2, x3, y3, x, y) <= EPS_SQUARE {
        return true
    }
    if distanceSquarePointToSegment(x3, y3, x1, y1, x, y) <= EPS_SQUARE {
        return true
    }
    return false
}

func main() {
    pts := [][2]float64{{0, 0}, {0, 1}, {3, 1}}
    tri := [][2]float64{{3.0 / 2, 12.0 / 5}, {51.0 / 10, -31.0 / 10}, {-19.0 / 5, 1.2}}
    fmt.Println("Triangle is", tri)
    x1, y1 := tri[0][0], tri[0][1]
    x2, y2 := tri[1][0], tri[1][1]
    x3, y3 := tri[2][0], tri[2][1]
    for _, pt := range pts {
        x, y := pt[0], pt[1]
        within := accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
        fmt.Println("Point", pt, "is within triangle?", within)
    }
    fmt.Println()
    tri = [][2]float64{{1.0 / 10, 1.0 / 9}, {100.0 / 8, 100.0 / 3}, {100.0 / 4, 100.0 / 9}}
    fmt.Println("Triangle is", tri)
    x1, y1 = tri[0][0], tri[0][1]
    x2, y2 = tri[1][0], tri[1][1]
    x3, y3 = tri[2][0], tri[2][1]
    x := x1 + (3.0/7)*(x2-x1)
    y := y1 + (3.0/7)*(y2-y1)
    pt := [2]float64{x, y}
    within := accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    fmt.Println("Point", pt, "is within triangle ?", within)
    fmt.Println()
    tri = [][2]float64{{1.0 / 10, 1.0 / 9}, {100.0 / 8, 100.0 / 3}, {-100.0 / 8, 100.0 / 6}}
    fmt.Println("Triangle is", tri)
    x3 = tri[2][0]
    y3 = tri[2][1]
    within = accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)
    fmt.Println("Point", pt, "is within triangle ?", within)
}
