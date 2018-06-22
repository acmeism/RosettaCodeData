package main

import (
	"fmt"
	"math/big"
)

func main() {
	var n, p int64
	fmt.Printf("A sample of permutations from 1 to 12:\n")
	for n = 1; n < 13; n++ {
		p = n / 3
		fmt.Printf("P(%d,%d) = %d\n", n, p, perm(big.NewInt(n), big.NewInt(p)))
	}
	fmt.Printf("\nA sample of combinations from 10 to 60:\n")
	for n = 10; n < 61; n += 10 {
		p = n / 3
		fmt.Printf("C(%d,%d) = %d\n", n, p, comb(big.NewInt(n), big.NewInt(p)))
	}
	fmt.Printf("\nA sample of permutations from 5 to 15000:\n")
	nArr := [...]int64{5, 50, 500, 1000, 5000, 15000}
	for _, n = range nArr {
		p = n / 3
		fmt.Printf("P(%d,%d) = %d\n", n, p, perm(big.NewInt(n), big.NewInt(p)))
	}
	fmt.Printf("\nA sample of combinations from 100 to 1000:\n")
	for n = 100; n < 1001; n += 100 {
		p = n / 3
		fmt.Printf("C(%d,%d) = %d\n", n, p, comb(big.NewInt(n), big.NewInt(p)))
	}
}

func fact(n *big.Int) *big.Int {
	if n.Sign() < 1 {
		return big.NewInt(0)
	}
	r := big.NewInt(1)
	i := big.NewInt(2)
	for i.Cmp(n) < 1 {
		r.Mul(r, i)
		i.Add(i, big.NewInt(1))
	}
	return r
}

func perm(n, k *big.Int) *big.Int {
	r := fact(n)
	r.Div(r, fact(n.Sub(n, k)))
	return r
}

func comb(n, r *big.Int) *big.Int {
	if r.Cmp(n) == 1 {
		return big.NewInt(0)
	}
	if r.Cmp(n) == 0 {
		return big.NewInt(1)
	}
	c := fact(n)
	den := fact(n.Sub(n, r))
	den.Mul(den, fact(r))
	c.Div(c, den)
	return c
}
