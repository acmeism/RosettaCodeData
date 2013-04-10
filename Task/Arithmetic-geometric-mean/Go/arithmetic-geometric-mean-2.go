package main

import (
    "fmt"
    "math"
    "math/cmplx"
)

const ε = 1e-14

func agm(a, g complex128) complex128 {
    for cmplx.Abs(a-g) > cmplx.Abs(a)*ε {
        a, g = (a+g)*.5, cmplx.Rect(math.Sqrt(cmplx.Abs(a)*cmplx.Abs(g)),
            (cmplx.Phase(a)+cmplx.Phase(g))*.5)
    }
    return a
}

func main() {
    fmt.Println(agm(1, 1/math.Sqrt2))
}
