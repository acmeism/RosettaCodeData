package main

import (
	"fmt"
	"math/big"
)

func bernoulli(z *big.Rat, n int64) *big.Rat {
	if z == nil {
		z = new(big.Rat)
	}
	a := make([]big.Rat, n+1)
	for m := range a {
		a[m].SetFrac64(1, int64(m+1))
		for j := m; j >= 1; j-- {
			d := &a[j-1]
			d.Mul(z.SetInt64(int64(j)), d.Sub(d, &a[j]))
		}
	}
	return z.Set(&a[0])
}

func main() {
	// allocate needed big.Rat's once
	q := new(big.Rat)
	c := new(big.Rat)      // coefficients
	be := new(big.Rat)     // for Bernoulli numbers
	bi := big.NewRat(1, 1) // for binomials

	for p := int64(0); p < 10; p++ {
		fmt.Print(p, " : ")
		q.SetFrac64(1, p+1)
		neg := true
		for j := int64(0); j <= p; j++ {
			neg = !neg
			if neg {
				c.Neg(q)
			} else {
				c.Set(q)
			}
			bi.Num().Binomial(p+1, j)
			bernoulli(be, j)
			c.Mul(c, bi)
			c.Mul(c, be)
			if c.Num().BitLen() == 0 {
				continue
			}
			if j == 0 {
				fmt.Printf(" %4s", c.RatString())
			} else {
				fmt.Printf(" %+2d/%-2d", c.Num(), c.Denom())
			}
			fmt.Print("×n")
			if exp := p + 1 - j; exp > 1 {
				fmt.Printf("^%-2d", exp)
			}
		}
		fmt.Println()
	}
}
