package main

import (
    "fmt"
    "math/big"
    "unsafe"
)

var one = big.NewInt(1)
var two = big.NewInt(2)
var three = big.NewInt(3)
var eight = big.NewInt(8)
var u uint
var uBits = int(unsafe.Sizeof(u))*8 - 1

func Ackermann2(m, n *big.Int) *big.Int {
    if m.Cmp(three) <= 0 {
        switch m.Int64() {
        case 0:
            return new(big.Int).Add(n, one)
        case 1:
            return new(big.Int).Add(n, two)
        case 2:
            r := new(big.Int).Lsh(n, 1)
            return r.Add(r, three)
        case 3:
            if n.BitLen() > uBits {
                panic("way too big")
            }
            r := new(big.Int).Lsh(eight, uint(n.Int64()))
            return r.Sub(r, three)
        }
    }
    if n.BitLen() == 0 {
        return Ackermann2(new(big.Int).Sub(m, one), one)
    }
    return Ackermann2(new(big.Int).Sub(m, one),
        Ackermann2(m, new(big.Int).Sub(n, one)))
}

func main() {
    show(0, 0)
    show(1, 2)
    show(2, 4)
    show(3, 100)
    show(4, 1)
    show(4, 3)
}

func show(m, n int64) {
    fmt.Printf("A(%d, %d) = ", m, n)
    fmt.Println(Ackermann2(big.NewInt(m), big.NewInt(n)))
}
