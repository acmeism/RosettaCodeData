package main

import (
    "fmt"
    "math/big"
)

const (
    mask0, bit0 = (1 << (1 << iota)) - 1, 1 << iota
    mask1, bit1
    mask2, bit2
    mask3, bit3
    mask4, bit4
    mask5, bit5
)

func rupb(x uint64) (out int) {
    if x == 0 {
        return -1
    }
    if x&^mask5 != 0 {
        x >>= bit5
        out |= bit5
    }
    if x&^mask4 != 0 {
        x >>= bit4
        out |= bit4
    }
    if x&^mask3 != 0 {
        x >>= bit3
        out |= bit3
    }
    if x&^mask2 != 0 {
        x >>= bit2
        out |= bit2
    }
    if x&^mask1 != 0 {
        x >>= bit1
        out |= bit1
    }
    if x&^mask0 != 0 {
        out |= bit0
    }
    return
}

func rlwb(x uint64) (out int) {
    if x == 0 {
        return 0
    }
    if x&mask5 == 0 {
        x >>= bit5
        out |= bit5
    }
    if x&mask4 == 0 {
        x >>= bit4
        out |= bit4
    }
    if x&mask3 == 0 {
        x >>= bit3
        out |= bit3
    }
    if x&mask2 == 0 {
        x >>= bit2
        out |= bit2
    }
    if x&mask1 == 0 {
        x >>= bit1
        out |= bit1
    }
    if x&mask0 == 0 {
        out |= bit0
    }
    return
}

// Big number versions of functions do not use the techniques of the ALGOL 68
// solution.  The big number version of rupb is trivial given one of the
// standard library functions, And for rlwb, I couldn't recommend shifting
// the whole input number when working with smaller numbers would do.
func rupbBig(x *big.Int) int {
    return x.BitLen() - 1
}

// Binary search, for the spirit of the task, but without shifting the input
// number x.  (Actually though, I don't recommend this either.  Linear search
// would be much faster.)
func rlwbBig(x *big.Int) int {
    if x.BitLen() < 2 {
        return 0
    }
    bit := uint(1)
    mask := big.NewInt(1)
    var ms []*big.Int
    var y, z big.Int
    for y.And(x, z.Lsh(mask, bit)).BitLen() == 0 {
        ms = append(ms, mask)
        mask = new(big.Int).Or(mask, &z)
        bit <<= 1
    }
    out := bit
    for i := len(ms) - 1; i >= 0; i-- {
        bit >>= 1
        if y.And(x, z.Lsh(ms[i], out)).BitLen() == 0 {
            out |= bit
        }
    }
    return int(out)
}

func main() {
    show()
    showBig()
}

func show() {
    fmt.Println("uint64:")
    fmt.Println("power              number  rupb  rlwb")
    const base = 42
    n := uint64(1)
    for i := 0; i < 12; i++ {
        fmt.Printf("%d^%02d %19d %5d %5d\n", base, i, n, rupb(n), rlwb(n))
        n *= base
    }
}

func showBig() {
    fmt.Println("\nbig numbers:")
    fmt.Println("  power                               number  rupb  rlwb")
    base := big.NewInt(1302)
    n := big.NewInt(1)
    for i := 0; i < 12; i++ {
        fmt.Printf("%d^%02d %36d %5d %5d\n", base, i, n, rupbBig(n), rlwbBig(n))
        n.Mul(n, base)
    }
}
