package main

import (
    "fmt"
    "math"
    "math/big"
)

func main() {
    // e and pi defined as constants.
    // In Go, that means they are not of a specific data type and can be used
    // as float32 or float64.  Println takes the float64 values.
    fmt.Println("float64 values:")
    fmt.Println("e:", math.E)
    fmt.Println("π:", math.Pi)

    // The following functions all take and return the float64 data type.

    // square root.  cube root also available (math.Cbrt)
    fmt.Println("square root(1.44):", math.Sqrt(1.44))
    // natural logarithm--log base 10, 2 also available (math.Log10, math.Log2)
    // also available is log1p, the log of 1+x.  (using log1p can be more
    // accurate when x is near zero.)
    fmt.Println("ln(e):", math.Log(math.E))
    // exponential.  also available are exp base 10, 2 (math.Pow10, math.Exp2)
    fmt.Println("exponential(1):", math.Exp(1))
    fmt.Println("absolute value(-1.2):", math.Abs(-1.2))
    fmt.Println("floor(-1.2):", math.Floor(-1.2))
    fmt.Println("ceiling(-1.2):", math.Ceil(-1.2))
    fmt.Println("power(1.44, .5):", math.Pow(1.44, .5))

    // Equivalent functions for the float32 type are not in the standard
    // library.  Here are the constants e and π as float32s however.
    fmt.Println("\nfloat32 values:")
    fmt.Println("e:", float32(math.E))
    fmt.Println("π:", float32(math.Pi))

    // The standard library has an arbitrary precision floating point type but
    // provides only the most basic methods.  Also while the constants math.E
    // and math.Pi are provided to over 80 decimal places, there is no
    // convenient way of loading these numbers (with their full precision)
    // into a big.Float.  A hack is cutting and pasting into a string, but
    // of course if you're going to do that you are free to cut and paste from
    // any other source.  (The documentation cites OEIS as its source.)
    pi := "3.141592653589793238462643383279502884197169399375105820974944"
    π, _, _ := big.ParseFloat(pi, 10, 200, 0)
    fmt.Println("\nbig.Float values:")
    fmt.Println("π:", π)
    // Of functions requested by the task, only absolute value is provided.
    x := new(big.Float).Neg(π)
    y := new(big.Float)
    fmt.Println("x:", x)
    fmt.Println("abs(x):", y.Abs(x))
}
