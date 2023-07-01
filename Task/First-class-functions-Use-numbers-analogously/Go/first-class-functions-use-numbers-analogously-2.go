package main

import "fmt"

func main() {
    x := 2.
    xi := .5
    y := 4.
    yi := .25
    z := func() float64 { return x + y }
    zi := func() float64 { return 1 / (x + y) }
    // point A

    numbers := []interface{}{&x, &y, z}
    inverses := []interface{}{&xi, &yi, zi}
    // point B

    mfs := make([]func(n interface{}) float64, len(numbers))
    for i := range mfs {
        mfs[i] = multiplier(numbers[i], inverses[i])
    }
    // pointC

    for _, mf := range mfs {
        fmt.Println(mf(1.))
    }
}

func multiplier(n1, n2 interface{}) func(interface{}) float64 {
    return func(m interface{}) float64 {
        // close on interface objects n1, n2, and m
        return eval(n1) * eval(n2) * eval(m)
    }
}

// utility function for evaluating multiplier interface objects
func eval(n interface{}) float64 {
    switch n.(type) {
    case float64:
        return n.(float64)
    case *float64:
        return *n.(*float64)
    case func() float64:
        return n.(func() float64)()
    }
    panic("unsupported multiplier type")
    return 0 // never reached
}
