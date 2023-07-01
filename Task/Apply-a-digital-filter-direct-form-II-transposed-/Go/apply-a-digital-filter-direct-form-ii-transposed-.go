package main

import "fmt"

type filter struct {
    b, a []float64
}

func (f filter) filter(in []float64) []float64 {
    out := make([]float64, len(in))
    s := 1. / f.a[0]
    for i := range in {
        tmp := 0.
        b := f.b
        if i+1 < len(b) {
            b = b[:i+1]
        }
        for j, bj := range b {
            tmp += bj * in[i-j]
        }
        a := f.a[1:]
        if i < len(a) {
            a = a[:i]
        }
        for j, aj := range a {
            tmp -= aj * out[i-j-1]
        }
        out[i] = tmp * s
    }
    return out
}

//Constants for a Butterworth filter (order 3, low pass)
var bwf = filter{
    a: []float64{1.00000000, -2.77555756e-16, 3.33333333e-01, -1.85037171e-17},
    b: []float64{0.16666667, 0.5, 0.5, 0.16666667},
}

var sig = []float64{
    -0.917843918645, 0.141984778794, 1.20536903482, 0.190286794412,
    -0.662370894973, -1.00700480494, -0.404707073677, 0.800482325044,
    0.743500089861, 1.01090520172, 0.741527555207, 0.277841675195,
    0.400833448236, -0.2085993586, -0.172842103641, -0.134316096293,
    0.0259303398477, 0.490105989562, 0.549391221511, 0.9047198589,
}

func main() {
    for _, v := range bwf.filter(sig) {
        fmt.Printf("%9.6f\n", v)
    }
}
