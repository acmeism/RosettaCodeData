package main

import (
	"fmt"
	"math/big"
	"math/bits" // Added in Go 1.9
)

var one = big.NewInt(1)
var two = big.NewInt(2)
var three = big.NewInt(3)
var eight = big.NewInt(8)

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
			if nb := n.BitLen(); nb > bits.UintSize {
				// n is too large to represent as a
				// uint for use in the Lsh method.
				panic(TooBigError(nb))

				// If we tried to continue anyway, doing
				// 8*2^n-3 as bellow, we'd use hundreds
				// of megabytes and lots of CPU time
				// without the Exp call even returning.
				r := new(big.Int).Exp(two, n, nil)
				r.Mul(eight, r)
				return r.Sub(r, three)
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

type TooBigError int

func (e TooBigError) Error() string {
	return fmt.Sprintf("A(m,n) had n of %d bits; too large", int(e))
}

func main() {
	show(0, 0)
	show(1, 2)
	show(2, 4)
	show(3, 100)
	show(3, 1e6)
	show(4, 1)
	show(4, 2)
	show(4, 3)
}

func show(m, n int64) {
	defer func() {
		// Ackermann2 could/should have returned an error
		// instead of a panic. But here's how to recover
		// from the panic, and report "expected" errors.
		if e := recover(); e != nil {
			if err, ok := e.(TooBigError); ok {
				fmt.Println("Error:", err)
			} else {
				panic(e)
			}
		}
	}()

	fmt.Printf("A(%d, %d) = ", m, n)
	a := Ackermann2(big.NewInt(m), big.NewInt(n))
	if a.BitLen() <= 256 {
		fmt.Println(a)
	} else {
		s := a.String()
		fmt.Printf("%d digits starting/ending with: %s...%s\n",
			len(s), s[:20], s[len(s)-20:],
		)
	}
}
