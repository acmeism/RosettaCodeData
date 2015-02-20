package main

import (
	"bytes"
	"fmt"
	"math/rand"
	"time"
)

func main() {
	const (
		m, n           = 10, 10
		t              = 1000
		minp, maxp, Δp = 0.1, 0.99, 0.1
	)

	// Purposely don't seed for a repeatable example grid:
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
		fmt.Printf("p=%.2f, %.3f\n", p, float64(count)/t)
	}
}

type cell struct {
	full        bool
	right, down bool // true if open to the right (x+1) or down (y+1)
}

type grid struct {
	cell [][]cell // row first, i.e. [y][x]
}

func NewGrid(p float64, xsize, ysize int) *grid {
	g := &grid{cell: make([][]cell, ysize)}
	for y := range g.cell {
		g.cell[y] = make([]cell, xsize)
		for x := 0; x < xsize-1; x++ {
			if rand.Float64() > p {
				g.cell[y][x].right = true
			}
			if rand.Float64() > p {
				g.cell[y][x].down = true
			}
		}
		if rand.Float64() > p {
			g.cell[y][xsize-1].down = true
		}
	}
	return g
}

var (
	full  = map[bool]string{false: "  ", true: "**"}
	hopen = map[bool]string{false: "--", true: "  "}
	vopen = map[bool]string{false: "|", true: " "}
)

func (g *grid) String() string {
	var buf bytes.Buffer
	// Don't really need to call Grow but it helps avoid multiple
	// reallocations if the size is large.
	buf.Grow((len(g.cell) + 1) * len(g.cell[0]) * 7)

	for _ = range g.cell[0] {
		buf.WriteString("+")
		buf.WriteString(hopen[false])
	}
	buf.WriteString("+\n")
	for y := range g.cell {
		buf.WriteString(vopen[false])
		for x := range g.cell[y] {
			buf.WriteString(full[g.cell[y][x].full])
			buf.WriteString(vopen[g.cell[y][x].right])
		}
		buf.WriteByte('\n')
		for x := range g.cell[y] {
			buf.WriteString("+")
			buf.WriteString(hopen[g.cell[y][x].down])
		}
		buf.WriteString("+\n")
	}
	ly := len(g.cell) - 1
	for x := range g.cell[ly] {
		buf.WriteByte(' ')
		buf.WriteString(full[g.cell[ly][x].down && g.cell[ly][x].full])
	}
	return buf.String()
}

func (g *grid) Percolate() bool {
	for x := range g.cell[0] {
		if g.fill(x, 0) {
			return true
		}
	}
	return false
}

func (g *grid) fill(x, y int) bool {
	if y >= len(g.cell) {
		return true // Out the bottom
	}
	if g.cell[y][x].full {
		return false // Allready filled
	}
	g.cell[y][x].full = true

	if g.cell[y][x].down && g.fill(x, y+1) {
		return true
	}
	if g.cell[y][x].right && g.fill(x+1, y) {
		return true
	}
	if x > 0 && g.cell[y][x-1].right && g.fill(x-1, y) {
		return true
	}
	if y > 0 && g.cell[y-1][x].down && g.fill(x, y-1) {
		return true
	}
	return false
}
