package main

import (
    "fmt"
    "math"
)

type matrix [][]float64
type binaryFunc64 func(float64, float64) float64

func like(m matrix) matrix {
    cols := len(m[0])
    r := make([][]float64, len(m))
    all := make([]float64, len(m)*cols)
    for i := range r {
        r[i] = all[i*cols : (i+1)*cols]
    }
    return r
}

func elementWiseMM(m1, m2 matrix, f binaryFunc64) matrix {
    z := like(m1)
    for rx, row := range m1 {
        for cx, ele := range row {
            z[rx][cx] = f(ele, m2[rx][cx])
        }
    }
    return z
}

func elementWiseMS(m matrix, s float64, f binaryFunc64) matrix {
    z := like(m)
    for rx, row := range m {
        for cx, ele := range row {
            z[rx][cx] = f(ele, s)
        }
    }
    return z
}

func add(a, b float64) float64 { return a + b }
func sub(a, b float64) float64 { return a - b }
func mul(a, b float64) float64 { return a * b }
func div(a, b float64) float64 { return a / b }
func exp(a, b float64) float64 { return math.Pow(a, b) }

func ewmmAdd(m1, m2 matrix) matrix { return elementWiseMM(m1, m2, add) }
func ewmmSub(m1, m2 matrix) matrix { return elementWiseMM(m1, m2, sub) }
func ewmmMul(m1, m2 matrix) matrix { return elementWiseMM(m1, m2, mul) }
func ewmmDiv(m1, m2 matrix) matrix { return elementWiseMM(m1, m2, div) }
func ewmmExp(m1, m2 matrix) matrix { return elementWiseMM(m1, m2, exp) }

func ewmsAdd(m matrix, s float64) matrix { return elementWiseMS(m, s, add) }
func ewmsSub(m matrix, s float64) matrix { return elementWiseMS(m, s, sub) }
func ewmsMul(m matrix, s float64) matrix { return elementWiseMS(m, s, mul) }
func ewmsDiv(m matrix, s float64) matrix { return elementWiseMS(m, s, div) }
func ewmsExp(m matrix, s float64) matrix { return elementWiseMS(m, s, exp) }

func main() {
    m1 := matrix{{3, 1, 4}, {1, 5, 9}}
    m2 := matrix{{2, 7, 1}, {8, 2, 8}}
    fmt.Println("m1:")
    m1.print()
    fmt.Println("m2:")
    m2.print()
    fmt.Println("m1 + m2:")
    ewmmAdd(m1, m2).print()
    fmt.Println("m1 - m2:")
    ewmmSub(m1, m2).print()
    fmt.Println("m1 * m2:")
    ewmmMul(m1, m2).print()
    fmt.Println("m1 / m2:")
    ewmmDiv(m1, m2).print()
    fmt.Println("m1 ^ m2:")
    ewmmExp(m1, m2).print()
    s := .5
    fmt.Println("s:", s)
    fmt.Println("m1 + s")
    ewmsAdd(m1, s).print()
    fmt.Println("m1 - s:")
    ewmsSub(m1, s).print()
    fmt.Println("m1 * s:")
    ewmsMul(m1, s).print()
    fmt.Println("m1 / s:")
    ewmsDiv(m1, s).print()
    fmt.Println("m1 ^ s:")
    ewmsExp(m1, s).print()
}

func (m matrix) print() {
    const f = "%6.3f "
    for _, r := range m {
        for _, e := range r {
            fmt.Printf(f, e)
        }
        fmt.Println()
    }
}
