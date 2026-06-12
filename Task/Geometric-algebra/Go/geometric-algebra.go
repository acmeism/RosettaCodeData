package main

import (
    "fmt"
    "math/rand"
    "time"
)

type vector []float64

func e(n uint) vector {
    if n > 4 {
        panic("n must be less than 5")
    }
    result := make(vector, 32)
    result[1<<n] = 1.0
    return result
}

func cdot(a, b vector) vector {
    return mul(vector{0.5}, add(mul(a, b), mul(b, a)))
}

func neg(x vector) vector {
    return mul(vector{-1}, x)
}

func bitCount(i int) int {
    i = i - ((i >> 1) & 0x55555555)
    i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
    i = (i + (i >> 4)) & 0x0F0F0F0F
    i = i + (i >> 8)
    i = i + (i >> 16)
    return i & 0x0000003F
}

func reorderingSign(i, j int) float64 {
    i >>= 1
    sum := 0
    for i != 0 {
        sum += bitCount(i & j)
        i >>= 1
    }
    cond := (sum & 1) == 0
    if cond {
        return 1.0
    }
    return -1.0
}

func add(a, b vector) vector {
    result := make(vector, 32)
    copy(result, a)
    for i, _ := range b {
        result[i] += b[i]
    }
    return result
}

func mul(a, b vector) vector {
    result := make(vector, 32)
    for i, _ := range a {
        if a[i] != 0 {
            for j, _ := range b {
                if b[j] != 0 {
                    s := reorderingSign(i, j) * a[i] * b[j]
                    k := i ^ j
                    result[k] += s
                }
            }
        }
    }
    return result
}

func randomVector() vector {
    result := make(vector, 32)
    for i := uint(0); i < 5; i++ {
        result = add(result, mul(vector{rand.Float64()}, e(i)))
    }
    return result
}

func randomMultiVector() vector {
    result := make(vector, 32)
    for i := 0; i < 32; i++ {
        result[i] = rand.Float64()
    }
    return result
}

func main() {
    rand.Seed(time.Now().UnixNano())
    for i := uint(0); i < 5; i++ {
        for j := uint(0); j < 5; j++ {
            if i < j {
                if cdot(e(i), e(j))[0] != 0 {
                    fmt.Println("Unexpected non-null scalar product.")
                    return
                }
            } else if i == j {
                if cdot(e(i), e(j))[0] == 0 {
                    fmt.Println("Unexpected null scalar product.")
                }
            }
        }
    }

    a := randomMultiVector()
    b := randomMultiVector()
    c := randomMultiVector()
    x := randomVector()

    // (ab)c == a(bc)
    fmt.Println(mul(mul(a, b), c))
    fmt.Println(mul(a, mul(b, c)))

    // a(b + c) == ab + ac
    fmt.Println(mul(a, add(b, c)))
    fmt.Println(add(mul(a, b), mul(a, c)))

    // (a + b)c == ac + bc
    fmt.Println(mul(add(a, b), c))
    fmt.Println(add(mul(a, c), mul(b, c)))

    // x² is real
    fmt.Println(mul(x, x))
}
