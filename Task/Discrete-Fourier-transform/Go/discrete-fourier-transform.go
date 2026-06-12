package main

import (
    "fmt"
    "math"
    "math/cmplx"
)

func dft(x []complex128) []complex128 {
    N := len(x)
    y := make([]complex128, N)
    for k := 0; k < N; k++ {
        for n := 0; n < N; n++ {
            t := -1i * 2 * complex(math.Pi*float64(k)*float64(n)/float64(N), 0)
            y[k] += x[n] * cmplx.Exp(t)
        }
    }
    return y
}

func idft(y []complex128) []float64 {
    N := len(y)
    x := make([]complex128, N)
    for n := 0; n < N; n++ {
        for k := 0; k < N; k++ {
            t := 1i * 2 * complex(math.Pi*float64(k)*float64(n)/float64(N), 0)
            x[n] += y[k] * cmplx.Exp(t)
        }
        x[n] /= complex(float64(N), 0)
        // clean x[n] to remove very small imaginary values
        if math.Abs(imag(x[n])) < 1e-14 {
            x[n] = complex(real(x[n]), 0)
        }
    }
    z := make([]float64, N)
    for i, c := range x {
        z[i] = float64(real(c))
    }
    return z
}

func main() {
    z := []float64{2, 3, 5, 7, 11}
    x := make([]complex128, len(z))
    fmt.Println("Original sequence:", z)
    for i, n := range z {
        x[i] = complex(n, 0)
    }
    y := dft(x)
    fmt.Println("\nAfter applying the Discrete Fourier Transform:")
    fmt.Printf("%0.14g", y)
    fmt.Println("\n\nAfter applying the Inverse Discrete Fourier Transform to the above transform:")
    z = idft(y)
    fmt.Printf("%0.14g", z)
    fmt.Println()
}
