package main

import "fmt"

type float float64

func kahan(s ...float) float {
    var tot, c float
    for _, x := range s {
        y := x - c
        t := tot + y
        c = (t - tot) - y
        tot = t
    }
    return tot
}

func epsilon() float {
    ε := float(1)
    for 1+ε != 1 {
        ε /= 2
    }
    return ε
}

func main() {
    a := float(1)
    b := epsilon()
    c := -b
    fmt.Println("Left associative:", a+b+c)
    fmt.Println("Kahan summation: ", kahan(a, b, c))
    fmt.Println("Epsilon:         ", b)
}
