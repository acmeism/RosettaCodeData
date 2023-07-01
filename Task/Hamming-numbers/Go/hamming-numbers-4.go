package main

import (
	"fmt"
	"math/big"
	"time"
)

// constants as expanded integers to minimize round-off errors, and
// reduce execution time using integer operations not float...
const cLAA2 uint64 = 35184372088832 // 2.0f64.ln() * 2.0f64.powi(45)).round() as u64;
const cLBA2 uint64 = 55765910372219 // 3.0f64.ln() / 2.0f64.ln() * 2.0f64.powi(45)).round() as u64;
const cLCA2 uint64 = 81695582054030 // 5.0f64.ln() / 2.0f64.ln() * 2.0f64.powi(45)).round() as u64;

type logelm struct { // log representation of an element with only allowable powers
	exp2 uint16
	exp3 uint16
	exp5 uint16
	logr uint64 // log representation used for comparison only - not exact
}

func (self *logelm) lte(othr *logelm) bool {
	if self.logr <= othr.logr {
		return true
	} else {
		return false
	}
}
func (self *logelm) mul2() logelm {
	return logelm{
		exp2: self.exp2 + 1,
		exp3: self.exp3,
		exp5: self.exp5,
		logr: self.logr + cLAA2,
	}
}
func (self *logelm) mul3() logelm {
	return logelm{
		exp2: self.exp2,
		exp3: self.exp3 + 1,
		exp5: self.exp5,
		logr: self.logr + cLBA2,
	}
}
func (self *logelm) mul5() logelm {
	return logelm{
		exp2: self.exp2,
		exp3: self.exp3,
		exp5: self.exp5 + 1,
		logr: self.logr + cLCA2,
	}
}

func log_nodups_hamming(n uint) *big.Int {
	if n < 1 {
		panic("log_nodups_hamming: argument < 1!")
	}
	if n < 2 { // trivial case of first in sequence
		return big.NewInt(1)
	}
	if n > 1.2e15 {
		panic("log_nodups_hamming: argument too large!")
	}

	one := logelm{}
	next5, merge := one.mul5(), one.mul3()
	next53, next532 := merge.mul3(), one.mul2()

	g := make([]logelm, 1, 65536)
	g[0] = one // never used, just so append works
	h := make([]logelm, 1, 65536)
	h[0] = one // never used, just so append works

	i, j := 1, 1
	for m := uint(1); m < n; m++ {
		cph := cap(h)
		if i >= cph/2 {
			nm := copy(h[0:i], h[i:])
			h = h[0:nm:cph]
			i = 0
		}
		if next532.lte(&merge) {
			h = append(h, next532)
			next532 = h[i].mul2()
			i++
		} else {
			h = append(h, merge)
			if next53.lte(&next5) {
				merge = next53
				next53 = g[j].mul3()
				j++
			} else {
				merge = next5
				next5 = next5.mul5()
			}
			cpg := cap(g)
			if j >= cpg/2 {
				nm := copy(g[0:j], g[j:])
				g = g[0:nm:cpg]
				j = 0
			}
			g = append(g, merge)
		}
	}

	two, three, five := big.NewInt(2), big.NewInt(3), big.NewInt(5)
	o := h[len(h)-1] // convert last element to big integer...
	ob := big.NewInt(1)
	for i := uint16(0); i < o.exp2; i++ {
		ob.Mul(two, ob)
	}
	for i := uint16(0); i < o.exp3; i++ {
		ob.Mul(three, ob)
	}
	for i := uint16(0); i < o.exp5; i++ {
		ob.Mul(five, ob)
	}
	return ob
}

func main() {
	n := uint(1e6)

	rarr := make([]*big.Int, 20)
	for i, _ := range rarr {
		rarr[i] = log_nodumps_hamming(i)
	}
	fmt.Println(rarr)

	fmt.Println(log_nodups_hamming(1691))

	strt := time.Now()

	rslt := log_nodups_hamming(n)

	end := time.Now()

	rs := rslt.String()
	lrs := len(rs)
	fmt.Printf("%v digits:\r\n", lrs)
	ndx := 0
	for ; ndx < lrs-100; ndx += 100 {
		fmt.Println(rs[ndx : ndx+100])
	}
	fmt.Println(rs[ndx:])

	fmt.Printf("This last found the %vth hamming number in %v.\r\n", n, end.Sub(strt))
}
