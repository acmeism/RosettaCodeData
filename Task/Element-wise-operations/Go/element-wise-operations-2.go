package main

import (
    "fmt"

    "element"
)

func h(heading string, m element.Matrix) {
    fmt.Println(heading)
    fmt.Print(m)
}

func main() {
    m1 := element.MatrixFromRows([][]float64{{3, 1, 4}, {1, 5, 9}})
    m2 := element.MatrixFromRows([][]float64{{2, 7, 1}, {8, 2, 8}})
    h("m1:", m1)
    h("m2:", m2)
    fmt.Println()
    h("m1 + m2:", element.AddMatrix(m1, m2))
    h("m1 - m2:", element.SubMatrix(m1, m2))
    h("m1 * m2:", element.MulMatrix(m1, m2))
    h("m1 / m2:", element.DivMatrix(m1, m2))
    h("m1 ^ m2:", element.ExpMatrix(m1, m2))
    fmt.Println()
    s := .5
    fmt.Println("s:", s)
    h("m1 + s:", element.AddScalar(m1, s))
    h("m1 - s:", element.SubScalar(m1, s))
    h("m1 * s:", element.MulScalar(m1, s))
    h("m1 / s:", element.DivScalar(m1, s))
    h("m1 ^ s:", element.ExpScalar(m1, s))
}
