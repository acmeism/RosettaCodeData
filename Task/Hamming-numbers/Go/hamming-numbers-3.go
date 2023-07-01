// Hamming project main.go
package main

import (
	"fmt"
	"math/big"
	"time"
)

type lazyList struct {
	head  *big.Int
	tail  *lazyList
	contf func() *lazyList
}

func (oll *lazyList) next() *lazyList {
	if oll.contf != nil { // not thread-safe
		oll.tail = oll.contf()
		oll.contf = nil
	}
	return oll.tail
}

func merge(a *lazyList, b *lazyList) *lazyList {
	rslt := new(lazyList)
	x := a.head
	y := b.head
	if x.Cmp(y) < 0 {
		rslt.head = x
		rslt.contf = func() *lazyList {
			return merge(a.next(), b)
		}
	} else {
		rslt.head = y
		rslt.contf = func() *lazyList {
			return merge(a, b.next())
		}
	}
	return rslt
}

func llmult(m *big.Int, ll *lazyList) *lazyList {
	rslt := new(lazyList)
	rslt.head = new(big.Int).Set(big.NewInt(0)).Mul(m, ll.head)
	rslt.contf = func() *lazyList {
		return llmult(m, ll.next())
	}
	return rslt
}

func u(s *lazyList, n *big.Int) *lazyList {
	rslt := new(lazyList)
	cr := new(lazyList)
	cr.head = big.NewInt(1)
	cr.contf = func() *lazyList {
		return rslt
	}
	if s == nil {
		rslt = llmult(n, cr)
	} else {
		rslt = merge(s, llmult(n, cr))
	}
	return rslt
}

func Hamming() func() *big.Int {
	prms := []int64{5, 3, 2}
	curr := new(lazyList)
	curr.head = big.NewInt(1)
	curr.contf = func() *lazyList {
		var r *lazyList = nil
		for _, v := range prms {
			r = u(r, big.NewInt(v))
		}
		return r
	}
	return func() *big.Int {
		temp := curr
		curr = curr.next()
		return temp.head
	}
}

func main() {
	n := 1000000

	hamiter := Hamming()
	rarr := make([]*big.Int, 20)
	for i, _ := range rarr {
		rarr[i] = hamiter()
	}
	fmt.Println(rarr)

	hamiter = Hamming()
	for i := 1; i < 1691; i++ {
		hamiter()
	}
	fmt.Println(hamiter())

	strt := time.Now()

	hamiter = Hamming()
	for i := 1; i < n; i++ {
		hamiter()
	}
	rslt := hamiter()

	end := time.Now()
	fmt.Printf("Found the %vth Hamming number as %v in %v.\r\n", n, rslt.String(), end.Sub(strt))
}
