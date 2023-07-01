package main

import (
    "fmt"
    "math"
)

type mwriter struct {
    value float64
    log   string
}

func (m mwriter) bind(f func(v float64) mwriter) mwriter {
    n := f(m.value)
    n.log = m.log + n.log
    return n
}

func unit(v float64, s string) mwriter {
    return mwriter{v, fmt.Sprintf("  %-17s: %g\n", s, v)}
}

func root(v float64) mwriter {
    return unit(math.Sqrt(v), "Took square root")
}

func addOne(v float64) mwriter {
    return unit(v+1, "Added one")
}

func half(v float64) mwriter {
    return unit(v/2, "Divided by two")
}

func main() {
    mw1 := unit(5, "Initial value")
    mw2 := mw1.bind(root).bind(addOne).bind(half)
    fmt.Println("The Golden Ratio is", mw2.value)
    fmt.Println("\nThis was derived as follows:-")
    fmt.Println(mw2.log)
}
