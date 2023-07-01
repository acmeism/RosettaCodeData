package main

import (
	"bytes"
	"fmt"
	"math/rand"
	"time"
)

func main() {
	const (
		m, n           = 15, 15
		t              = 1e4
		minp, maxp, Δp = 0, 1, 0.1
	)

	rand.Seed(2) // Fixed seed for repeatable example grid
	g := NewGrid(.5, m, n)
	g.Percolate()
	fmt.Println(g)

	rand.Seed(time.Now().UnixNano()) // could pick a better seed
	for p := float64(minp); p < maxp; p += Δp {
		count := 0
		for i := 0; i < t; i++ {
			g := NewGrid(p, m, n)
			if g.Percolate() {
				count++
			}
		}
		fmt.Printf("p=%.2f, %.4f\n", p, float64(count)/t)
	}
}

const (
	full  = '.'
	used  = '#'
	empty = ' '
)

type grid struct {
	cell [][]byte // row first, i.e. [y][x]
}

func NewGrid(p float64, xsize, ysize int) *grid {
	g := &grid{cell: make([][]byte, ysize)}
	for y := range g.cell {
		g.cell[y] = make([]byte, xsize)
		for x := range g.cell[y] {
			if rand.Float64() < p {
				g.cell[y][x] = full
			} else {
				g.cell[y][x] = empty
			}
		}
	}
	return g
}

func (g *grid) String() string {
	var buf bytes.Buffer
	// Don't really need to call Grow but it helps avoid multiple
	// reallocations if the size is large.
	buf.Grow((len(g.cell) + 2) * (len(g.cell[0]) + 3))

	buf.WriteByte('+')
	for _ = range g.cell[0] {
		buf.WriteByte('-')
	}
	buf.WriteString("+\n")

	for y := range g.cell {
		buf.WriteByte('|')
		buf.Write(g.cell[y])
		buf.WriteString("|\n")
	}

	buf.WriteByte('+')
	ly := len(g.cell) - 1
	for x := range g.cell[ly] {
		if g.cell[ly][x] == used {
			buf.WriteByte(used)
		} else {
			buf.WriteByte('-')
		}
	}
	buf.WriteByte('+')
	return buf.String()
}

func (g *grid) Percolate() bool {
	for x := range g.cell[0] {
		if g.use(x, 0) {
			return true
		}
	}
	return false
}

func (g *grid) use(x, y int) bool {
	if y < 0 || x < 0 || x >= len(g.cell[0]) || g.cell[y][x] != full {
		return false // Off the edges, empty, or used
	}
	g.cell[y][x] = used
	if y+1 == len(g.cell) {
		return true // We're on the bottom
	}

	// Try down, right, left, up in that order.
	return g.use(x, y+1) ||
		g.use(x+1, y) ||
		g.use(x-1, y) ||
		g.use(x, y-1)
}
