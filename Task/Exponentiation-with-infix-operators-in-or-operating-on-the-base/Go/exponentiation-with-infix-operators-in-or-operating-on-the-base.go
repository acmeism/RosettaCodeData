package main

import (
    "fmt"
    "math"
)

type float float64

func (f float) p(e float) float { return float(math.Pow(float64(f), float64(e))) }

func main() {
    ops := []string{"-x.p(e)", "-(x).p(e)", "(-x).p(e)", "-(x.p(e))"}
    for _, x := range []float{float(-5), float(5)} {
        for _, e := range []float{float(2), float(3)} {
            fmt.Printf("x = %2.0f e = %0.0f | ", x, e)
            fmt.Printf("%s = %4.0f | ", ops[0], -x.p(e))
            fmt.Printf("%s = %4.0f | ", ops[1], -(x).p(e))
            fmt.Printf("%s = %4.0f | ", ops[2], (-x).p(e))
            fmt.Printf("%s = %4.0f\n", ops[3], -(x.p(e)))
        }
    }
}
