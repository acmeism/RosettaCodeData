package main

import (
	"fmt"
	"math"
	"math/rand"
	"runtime"
	"time"
)

type ProbeRes struct {
	np   int
	p, d float64
}

type Frac struct {
	n int
	d int
}

var DaysInYear int = 365

func main() {
	sigma := 5.0
	for i := 2; i <= 5; i++ {
		res := GetNP(i, sigma, 0.5)
		fmt.Printf("%d collision: %d people, P = %.4f ± %.4f\n",
			i, res.np, res.p, res.d)
	}
}

func GetNP(n int, n_sigmas, p_thresh float64) (res ProbeRes) {
	res.np = DaysInYear * (n - 1)
	for i := 0; i < DaysInYear*(n-1); i++ {
		tmp := probe(i, n, n_sigmas, p_thresh)
		if tmp.p > p_thresh && tmp.np < res.np {
			res = tmp
		}
	}
	return
}

var numCPU = runtime.NumCPU()

func probe(np, n int, n_sigmas, p_thresh float64) ProbeRes {
	var p, d float64
	var runs, yes int
	cRes := make(chan Frac, numCPU)
	for i := 0; i < numCPU; i++ {
		go SimN(np, n, 25, cRes)
	}
	for math.Abs(p-p_thresh) < n_sigmas*d || runs < 100 {
		f := <-cRes
		yes += f.n
		runs += f.d
		p = float64(yes) / float64(runs)
		d = math.Sqrt(p * (1 - p) / float64(runs))
		go SimN(np, n, runs/3, cRes)

	}
	return ProbeRes{np, p, d}
}
func SimN(np, n, ssize int, c chan Frac) {
	r := rand.New(rand.NewSource(time.Now().UnixNano() + rand.Int63()))
	yes := 0
	for i := 0; i < ssize; i++ {
		if Sim(np, n, r) {
			yes++
		}

	}
	c <- Frac{yes, ssize}
}
func Sim(p, n int, r *rand.Rand) (res bool) {
	Cal := make([]int, DaysInYear)
	for i := 0; i < p; i++ {
		Cal[r.Intn(DaysInYear)]++
	}
	for _, v := range Cal {
		if v >= n {
			res = true
		}
	}
	return
}
