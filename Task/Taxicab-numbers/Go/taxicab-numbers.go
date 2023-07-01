package main

import (
	"container/heap"
	"fmt"
	"strings"
)

type CubeSum struct {
	x, y  uint16
	value uint64
}

func (c *CubeSum) fixvalue() { c.value = cubes[c.x] + cubes[c.y] }

type CubeSumHeap []*CubeSum

func (h CubeSumHeap) Len() int            { return len(h) }
func (h CubeSumHeap) Less(i, j int) bool  { return h[i].value < h[j].value }
func (h CubeSumHeap) Swap(i, j int)       { h[i], h[j] = h[j], h[i] }
func (h *CubeSumHeap) Push(x interface{}) { (*h) = append(*h, x.(*CubeSum)) }
func (h *CubeSumHeap) Pop() interface{} {
	x := (*h)[len(*h)-1]
	*h = (*h)[:len(*h)-1]
	return x
}

type TaxicabGen struct {
	n int
	h CubeSumHeap
}

var cubes []uint64 // cubes[i] == i*i*i
func cubesExtend(i int) {
	for n := uint64(len(cubes)); n <= uint64(i); n++ {
		cubes = append(cubes, n*n*n)
	}
}

func (g *TaxicabGen) min() CubeSum {
	for len(g.h) == 0 || g.h[0].value > cubes[g.n] {
		g.n++
		cubesExtend(g.n)
		heap.Push(&g.h, &CubeSum{uint16(g.n), 1, cubes[g.n] + 1})
	}
	// Note, we use g.h[0] to "peek" at the min heap entry.
	c := *(g.h[0])
	if c.y+1 <= c.x {
		// Instead of Pop and Push we modify in place and fix.
		g.h[0].y++
		g.h[0].fixvalue()
		heap.Fix(&g.h, 0)
	} else {
		heap.Pop(&g.h)
	}
	return c
}

// Originally this was just: type Taxicab [2]CubeSum
// and we always returned two sums. Now we return all the sums.
type Taxicab []CubeSum

func (t Taxicab) String() string {
	var b strings.Builder
	fmt.Fprintf(&b, "%12d", t[0].value)
	for _, p := range t {
		fmt.Fprintf(&b, " =%5d³ +%5d³", p.x, p.y)
	}
	return b.String()
}

func (g *TaxicabGen) Next() Taxicab {
	a, b := g.min(), g.min()
	for a.value != b.value {
		a, b = b, g.min()
	}
	//return Taxicab{a,b}

	// Originally this just returned Taxicab{a,b} and we didn't look
	// further into the heap. Since we start by looking at the next
	// pair, that is okay until the first Taxicab number with four
	// ways of expressing the cube, which doesn't happen until the
	// 97,235th Taxicab:
	//     6963472309248 = 16630³ + 13322³ = 18072³ + 10200³
	//                   = 18948³ +  5436³ = 19083³ +  2421³
	// Now we return all ways so we need to peek into the heap.
	t := Taxicab{a, b}
	for g.h[0].value == b.value {
		t = append(t, g.min())
	}
	return t
}

func main() {
	const (
		low  = 25
		mid  = 2e3
		high = 4e4
	)
	var tg TaxicabGen
	firstn := 3 // To show the first triple, quadruple, etc
	for i := 1; i <= high+6; i++ {
		t := tg.Next()
		switch {
		case len(t) >= firstn:
			firstn++
			fallthrough
		case i <= low || (mid <= i && i <= mid+6) || i >= high:
			//fmt.Printf("h:%-4d  ", len(tg.h))
			fmt.Printf("%5d: %v\n", i, t)
		}
	}
}
