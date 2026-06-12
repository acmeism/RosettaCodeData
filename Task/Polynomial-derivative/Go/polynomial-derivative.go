package main

import (
    "fmt"
    "strings"
)

func derivative(p []int) []int {
    if len(p) == 1 {
        return []int{0}
    }
    d := make([]int, len(p)-1)
    copy(d, p[1:])
    for i := 0; i < len(d); i++ {
        d[i] = p[i+1] * (i + 1)
    }
    return d
}

var ss = []string{"", "", "\u00b2", "\u00b3", "\u2074", "\u2075", "\u2076", "\u2077", "\u2078", "\u2079"}

// for n <= 20
func superscript(n int) string {
    if n < 10 {
        return ss[n]
    }
    if n < 20 {
        return ss[1] + ss[n-10]
    }
    return ss[2] + ss[0]
}

func abs(n int) int {
    if n < 0 {
        return -n
    }
    return n
}

func polyPrint(p []int) string {
    if len(p) == 1 {
        return fmt.Sprintf("%d", p[0])
    }
    var terms []string
    for i := 0; i < len(p); i++ {
        if p[i] == 0 {
            continue
        }
        c := fmt.Sprintf("%d", p[i])
        if i > 0 && abs(p[i]) == 1 {
            c = ""
            if p[i] != 1 {
                c = "-"
            }
        }
        x := "x"
        if i <= 0 {
            x = ""
        }
        terms = append(terms, fmt.Sprintf("%s%s%s", c, x, superscript(i)))
    }
    for i, j := 0, len(terms)-1; i < j; i, j = i+1, j-1 {
        terms[i], terms[j] = terms[j], terms[i]
    }
    s := strings.Join(terms, "+")
    return strings.Replace(s, "+-", "-", -1)
}

func main() {
    fmt.Println("The derivatives of the following polynomials are:\n")
    polys := [][]int{{5}, {4, -3}, {-1, 6, 5}, {-4, 3, -2, 1}, {1, 1, 0, -1, -1}}
    for _, poly := range polys {
        deriv := derivative(poly)
        fmt.Printf("%v -> %v\n", poly, deriv)
    }
    fmt.Println("\nOr in normal mathematical notation:\n")
    for _, poly := range polys {
        deriv := derivative(poly)
        fmt.Println("Polynomial : ", polyPrint(poly))
        fmt.Println("Derivative : ", polyPrint(deriv), "\n")
    }
}
