package main

import (
    "fmt"
    "math"
)

type vector struct{ x, y, z float64 }

func (v vector) add(w vector) vector {
    return vector{v.x + w.x, v.y + w.y, v.z + w.z}
}

func (v vector) mul(m float64) vector {
    return vector{v.x * m, v.y * m, v.z * m}
}

func (v vector) div(d float64) vector {
    return v.mul(1.0 / d)
}

func (v vector) abs() float64 {
    return math.Sqrt(v.x*v.x + v.y*v.y + v.z*v.z)
}

func (v vector) String() string {
    return fmt.Sprintf("(%g, %g, %g)", v.x, v.y, v.z)
}

func orbitalStateVectors(
    semimajorAxis, eccentricity, inclination, longitudeOfAscendingNode,
    argumentOfPeriapsis, trueAnomaly float64) (position vector, speed vector) {

    i := vector{1, 0, 0}
    j := vector{0, 1, 0}
    k := vector{0, 0, 1}

    mulAdd := func(v1, v2 vector, x1, x2 float64) vector {
        return v1.mul(x1).add(v2.mul(x2))
    }

    rotate := func(i, j vector, alpha float64) (vector, vector) {
        return mulAdd(i, j, math.Cos(alpha), math.Sin(alpha)),
            mulAdd(i, j, -math.Sin(alpha), math.Cos(alpha))
    }

    i, j = rotate(i, j, longitudeOfAscendingNode)
    j, _ = rotate(j, k, inclination)
    i, j = rotate(i, j, argumentOfPeriapsis)

    l := 2.0
    if eccentricity != 1.0 {
        l = 1.0 - eccentricity*eccentricity
    }
    l *= semimajorAxis
    c := math.Cos(trueAnomaly)
    s := math.Sin(trueAnomaly)
    r := l / (1.0 + eccentricity*c)
    rprime := s * r * r / l
    position = mulAdd(i, j, c, s).mul(r)
    speed = mulAdd(i, j, rprime*c-r*s, rprime*s+r*c)
    speed = speed.div(speed.abs())
    speed = speed.mul(math.Sqrt(2.0/r - 1.0/semimajorAxis))
    return
}

func main() {
    long := 355.0 / (113.0 * 6.0)
    position, speed := orbitalStateVectors(1.0, 0.1, 0.0, long, 0.0, 0.0)
    fmt.Println("Position :", position)
    fmt.Println("Speed    :", speed)
}
