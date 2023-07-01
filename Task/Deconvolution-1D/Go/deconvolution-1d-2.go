package main

import (
    "fmt"
    "math"
    "math/cmplx"
)

func main() {
    h := []float64{-8, -9, -3, -1, -6, 7}
    f := []float64{-3, -6, -1, 8, -6, 3, -1, -9, -9, 3, -2, 5, 2, -2, -7, -1}
    g := []float64{24, 75, 71, -34, 3, 22, -45, 23, 245, 25, 52, 25, -67, -96,
        96, 31, 55, 36, 29, -43, -7}
    fmt.Printf("%.1f\n", h)
    fmt.Printf("%.1f\n", deconv(g, f))
    fmt.Printf("%.1f\n", f)
    fmt.Printf("%.1f\n", deconv(g, h))
}

func deconv(g, f []float64) []float64 {
    n := 1
    for n < len(g) {
        n *= 2
    }
    g2 := make([]complex128, n)
    for i, x := range g {
        g2[i] = complex(x, 0)
    }
    f2 := make([]complex128, n)
    for i, x := range f {
        f2[i] = complex(x, 0)
    }
    gt := fft(g2)
    ft := fft(f2)
    for i := range gt {
        gt[i] /= ft[i]
    }
    ht := fft(gt)
    it := 1 / float64(n)
    out := make([]float64, len(g)-len(f)+1)
    out[0] = real(ht[0]) * it
    for i := 1; i < len(out); i++ {
        out[i] = real(ht[n-i]) * it
    }
    return out
}

func fft(in []complex128) []complex128 {
    out := make([]complex128, len(in))
    ditfft2(in, out, len(in), 1)
    return out
}

func ditfft2(x, y []complex128, n, s int) {
    if n == 1 {
        y[0] = x[0]
        return
    }
    ditfft2(x, y, n/2, 2*s)
    ditfft2(x[s:], y[n/2:], n/2, 2*s)
    for k := 0; k < n/2; k++ {
        tf := cmplx.Rect(1, -2*math.Pi*float64(k)/float64(n)) * y[k+n/2]
        y[k], y[k+n/2] = y[k]+tf, y[k]-tf
    }
}
