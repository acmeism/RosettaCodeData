package main

import (
	"fmt"
	"math/big"
	"time"

	"github.com/jbarham/primegen.go"
)

func main() {
	start := time.Now()
	pg := primegen.New()
	var i uint64
	p := big.NewInt(1)
	tmp := new(big.Int)
	for i <= 9 {
		fmt.Printf("primorial(%v) = %v\n", i, p)
		i++
		p = p.Mul(p, tmp.SetUint64(pg.Next()))
	}
	for _, j := range []uint64{1e1, 1e2, 1e3, 1e4, 1e5, 1e6} {
		for i < j {
			i++
			p = p.Mul(p, tmp.SetUint64(pg.Next()))
		}
		fmt.Printf("primorial(%v) has %v digits", i, len(p.String()))
		fmt.Printf("\t(after %v)\n", time.Since(start))
	}
}
