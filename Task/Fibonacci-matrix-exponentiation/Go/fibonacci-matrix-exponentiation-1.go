package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "time"
)

type vector = []*big.Int
type matrix []vector

var (
    zero = new(big.Int)
    one  = big.NewInt(1)
)

func (m1 matrix) mul(m2 matrix) matrix {
    rows1, cols1 := len(m1), len(m1[0])
    rows2, cols2 := len(m2), len(m2[0])
    if cols1 != rows2 {
        panic("Matrices cannot be multiplied.")
    }
    result := make(matrix, rows1)
    temp := new(big.Int)
    for i := 0; i < rows1; i++ {
        result[i] = make(vector, cols2)
        for j := 0; j < cols2; j++ {
            result[i][j] = new(big.Int)
            for k := 0; k < rows2; k++ {
                temp.Mul(m1[i][k], m2[k][j])
                result[i][j].Add(result[i][j], temp)
            }
        }
    }
    return result
}

func identityMatrix(n uint64) matrix {
    if n < 1 {
        panic("Size of identity matrix can't be less than 1")
    }
    ident := make(matrix, n)
    for i := uint64(0); i < n; i++ {
        ident[i] = make(vector, n)
        for j := uint64(0); j < n; j++ {
            ident[i][j] = new(big.Int)
            if i == j {
                ident[i][j].Set(one)
            }
        }
    }
    return ident
}

func (m matrix) pow(n *big.Int) matrix {
    le := len(m)
    if le != len(m[0]) {
        panic("Not a square matrix")
    }
    switch {
    case n.Cmp(zero) == -1:
        panic("Negative exponents not supported")
    case n.Cmp(zero) == 0:
        return identityMatrix(uint64(le))
    case n.Cmp(one) == 0:
        return m
    }
    pow := identityMatrix(uint64(le))
    base := m
    e := new(big.Int).Set(n)
    temp := new(big.Int)
    for e.Cmp(zero) > 0 {
        temp.And(e, one)
        if temp.Cmp(one) == 0 {
            pow = pow.mul(base)
        }
        e.Rsh(e, 1)
        base = base.mul(base)
    }
    return pow
}

func fibonacci(n *big.Int) *big.Int {
    if n.Cmp(zero) == 0 {
        return zero
    }
    m := matrix{{one, one}, {one, zero}}
    m = m.pow(n.Sub(n, one))
    return m[0][0]
}

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    start := time.Now()
    n := new(big.Int)
    for i := uint64(10); i <= 1e7; i *= 10 {
        n.SetUint64(i)
        s := fibonacci(n).String()
        fmt.Printf("The digits of the %sth Fibonacci number (%s) are:\n",
            commatize(i), commatize(uint64(len(s))))
        if len(s) > 20 {
            fmt.Printf("  First 20 : %s\n", s[0:20])
            if len(s) < 40 {
                fmt.Printf("  Final %-2d : %s\n", len(s)-20, s[20:])
            } else {
                fmt.Printf("  Final 20 : %s\n", s[len(s)-20:])
            }
        } else {
            fmt.Printf("  All %-2d   : %s\n", len(s), s)
        }
        fmt.Println()
    }

    sfxs := []string{"nd", "th"}
    for i, e := range []uint{16, 32} {
        n.Lsh(one, e)
        s := fibonacci(n).String()
        fmt.Printf("The digits of the 2^%d%s Fibonacci number (%s) are:\n", e, sfxs[i],
            commatize(uint64(len(s))))
        fmt.Printf("  First 20 : %s\n", s[0:20])
        fmt.Printf("  Final 20 : %s\n", s[len(s)-20:])
        fmt.Println()
    }

    fmt.Printf("Took %s\n\n", time.Since(start))
}
