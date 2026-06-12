package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

type ff = func([]float64) float64

type parameters struct{ omega, phip, phig float64 }

type state struct {
    iter       int
    gbpos      []float64
    gbval      float64
    min        []float64
    max        []float64
    params     parameters
    pos        [][]float64
    vel        [][]float64
    bpos       [][]float64
    bval       []float64
    nParticles int
    nDims      int
}

func (s state) report(testfunc string) {
    fmt.Println("Test Function        :", testfunc)
    fmt.Println("Iterations           :", s.iter)
    fmt.Println("Global Best Position :", s.gbpos)
    fmt.Println("Global Best Value    :", s.gbval)
}

func psoInit(min, max []float64, params parameters, nParticles int) *state {
    nDims := len(min)
    pos := make([][]float64, nParticles)
    vel := make([][]float64, nParticles)
    bpos := make([][]float64, nParticles)
    bval := make([]float64, nParticles)
    for i := 0; i < nParticles; i++ {
        pos[i] = min
        vel[i] = make([]float64, nDims)
        bpos[i] = min
        bval[i] = math.Inf(1)
    }
    iter := 0
    gbpos := make([]float64, nDims)
    for i := 0; i < nDims; i++ {
        gbpos[i] = math.Inf(1)
    }
    gbval := math.Inf(1)
    return &state{iter, gbpos, gbval, min, max, params,
        pos, vel, bpos, bval, nParticles, nDims}
}

func pso(fn ff, y *state) *state {
    p := y.params
    v := make([]float64, y.nParticles)
    bpos := make([][]float64, y.nParticles)
    bval := make([]float64, y.nParticles)
    gbpos := make([]float64, y.nDims)
    gbval := math.Inf(1)
    for j := 0; j < y.nParticles; j++ {
        // evaluate
        v[j] = fn(y.pos[j])
        // update
        if v[j] < y.bval[j] {
            bpos[j] = y.pos[j]
            bval[j] = v[j]
        } else {
            bpos[j] = y.bpos[j]
            bval[j] = y.bval[j]
        }
        if bval[j] < gbval {
            gbval = bval[j]
            gbpos = bpos[j]
        }
    }
    rg := rand.Float64()
    pos := make([][]float64, y.nParticles)
    vel := make([][]float64, y.nParticles)
    for j := 0; j < y.nParticles; j++ {
        pos[j] = make([]float64, y.nDims)
        vel[j] = make([]float64, y.nDims)
        // migrate
        rp := rand.Float64()
        ok := true
        for z := 0; z < y.nDims; z++ {
            pos[j][z] = 0
            vel[j][z] = 0
        }
        for k := 0; k < y.nDims; k++ {
            vel[j][k] = p.omega*y.vel[j][k] +
                p.phip*rp*(bpos[j][k]-y.pos[j][k]) +
                p.phig*rg*(gbpos[k]-y.pos[j][k])
            pos[j][k] = y.pos[j][k] + vel[j][k]
            ok = ok && y.min[k] < pos[j][k] && y.max[k] > pos[j][k]
        }
        if !ok {
            for k := 0; k < y.nDims; k++ {
                pos[j][k] = y.min[k] + (y.max[k]-y.min[k])*rand.Float64()
            }
        }
    }
    iter := 1 + y.iter
    return &state{iter, gbpos, gbval, y.min, y.max, y.params,
        pos, vel, bpos, bval, y.nParticles, y.nDims}
}

func iterate(fn ff, n int, y *state) *state {
    r := y
    for i := 0; i < n; i++ {
        r = pso(fn, r)
    }
    return r
}

func mccormick(x []float64) float64 {
    a, b := x[0], x[1]
    return math.Sin(a+b) + (a-b)*(a-b) + 1.0 + 2.5*b - 1.5*a
}

func michalewicz(x []float64) float64 {
    m := 10.0
    sum := 0.0
    for i := 1; i <= len(x); i++ {
        j := x[i-1]
        k := math.Sin(float64(i) * j * j / math.Pi)
        sum += math.Sin(j) * math.Pow(k, 2*m)
    }
    return -sum
}

func main() {
    rand.Seed(time.Now().UnixNano())
    st := psoInit(
        []float64{-1.5, -3.0},
        []float64{4.0, 4.0},
        parameters{0.0, 0.6, 0.3},
        100,
    )
    st = iterate(mccormick, 40, st)
    st.report("McCormick")
    fmt.Println("f(-.54719, -1.54719) :", mccormick([]float64{-.54719, -1.54719}))
    fmt.Println()
    st = psoInit(
        []float64{0.0, 0.0},
        []float64{math.Pi, math.Pi},
        parameters{0.3, 0.3, 0.3},
        1000,
    )
    st = iterate(michalewicz, 30, st)
    st.report("Michalewicz (2D)")
    fmt.Println("f(2.20, 1.57)        :", michalewicz([]float64{2.2, 1.57}))
}
