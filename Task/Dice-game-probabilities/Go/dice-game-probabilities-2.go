package main

import (
	"fmt"
	"math/rand"
)

type set struct {
	n, s int
}

func (s set) roll() (sum int) {
	for i := 0; i < s.n; i++ {
		sum += rand.Intn(s.s) + 1
	}
	return
}

func (s set) beats(o set, n int) (p float64) {
	for i := 0; i < n; i++ {
		if s.roll() > o.roll() {
			p = p + 1.0
		}
	}
	p = p / float64(n)
	return
}

func main() {
	fmt.Println(set{9, 4}.beats(set{6, 6}, 1000))
	fmt.Println(set{5, 10}.beats(set{6, 7}, 1000))
}
