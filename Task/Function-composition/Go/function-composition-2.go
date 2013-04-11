package main

import "math"
import "fmt"

type ffType func(float64) float64

func compose(f, g ffType) ffType {
    return func(x float64) float64 {
        return f(g(x))
    }
}

func main() {
    sin_asin := compose(math.Sin, math.Asin)
    fmt.Println(sin_asin(.5))
}
