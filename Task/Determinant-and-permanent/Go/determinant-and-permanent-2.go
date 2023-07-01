package main

import "fmt"

func main() {
    fmt.Println(ryser([][]float64{
        {1, 2},
        {3, 4}}))
    fmt.Println(ryser([][]float64{
        {2, 9, 4},
        {7, 5, 3},
        {6, 1, 8}}))
}

func ryser(m [][]float64) (d float64) {
    gray := 0
    csum := make([]float64, len(m))
    sgn := float64(len(m)&1<<1 - 1)
    n2 := uint32(1) << uint(len(m))
    for i := uint32(1); i < n2; i++ {
        r := [...]byte{
            0, 1, 28, 2, 29, 14, 24, 3, 30, 22, 20, 15, 25, 17, 4, 8,
            31, 27, 13, 23, 21, 19, 16, 7, 26, 12, 18, 6, 11, 5, 10, 9,
        }[i&-i*0x077CB531>>27]
        b := 1 << r
        if gray&b == 0 {
            for c, e := range m[r] {
                csum[c] += e
            }
        } else {
            for c, e := range m[r] {
                csum[c] -= e
            }
        }
        gray ^= b
        p := sgn
        for _, e := range csum {
            p *= e
        }
        d += p
        sgn = -sgn
    }
    return
}
