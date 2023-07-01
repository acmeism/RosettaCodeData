package main

import (
        "fmt"
        "math"
)

func PowN(b float64) func(float64) float64 {
        return func(e float64) float64 { return math.Pow(b, e) }
}

func PowE(e float64) func(float64) float64 {
        return func(b float64) float64 { return math.Pow(b, e) }
}

type Foo int

func (f Foo) Method(b int) int {
        return int(f) + b
}

func main() {
        pow2 := PowN(2)
        cube := PowE(3)

        fmt.Println("2^8 =", pow2(8))
        fmt.Println("4³ =", cube(4))

        var a Foo = 2
        fn1 := a.Method   // A "method value", like currying 'a'
        fn2 := Foo.Method // A "method expression", like uncurrying

        fmt.Println("2 + 2 =", a.Method(2)) // regular method call
        fmt.Println("2 + 3 =", fn1(3))
        fmt.Println("2 + 4 =", fn2(a, 4))
        fmt.Println("3 + 5 =", fn2(Foo(3), 5))
}
