package main

import (
    "log"
    "math/rand"
    "testing"
    "time"

    "github.com/gonum/plot"
    "github.com/gonum/plot/plotter"
    "github.com/gonum/plot/plotutil"
    "github.com/gonum/plot/vg"
)

// Step 1, sort routines.
// These functions are copied without changes from the RC tasks Bubble Sort,
// Insertion sort, and Quicksort.

func bubblesort(a []int) {
    for itemCount := len(a) - 1; ; itemCount-- {
        hasChanged := false
        for index := 0; index < itemCount; index++ {
            if a[index] > a[index+1] {
                a[index], a[index+1] = a[index+1], a[index]
                hasChanged = true
            }
        }
        if hasChanged == false {
            break
        }
    }
}

func insertionsort(a []int) {
    for i := 1; i < len(a); i++ {
        value := a[i]
        j := i - 1
        for j >= 0 && a[j] > value {
            a[j+1] = a[j]
            j = j - 1
        }
        a[j+1] = value
    }
}

func quicksort(a []int) {
    var pex func(int, int)
    pex = func(lower, upper int) {
        for {
            switch upper - lower {
            case -1, 0:
                return
            case 1:
                if a[upper] < a[lower] {
                    a[upper], a[lower] = a[lower], a[upper]
                }
                return
            }
            bx := (upper + lower) / 2
            b := a[bx]
            lp := lower
            up := upper
        outer:
            for {
                for lp < upper && !(b < a[lp]) {
                    lp++
                }
                for {
                    if lp > up {
                        break outer
                    }
                    if a[up] < b {
                        break
                    }
                    up--
                }
                a[lp], a[up] = a[up], a[lp]
                lp++
                up--
            }
            if bx < lp {
                if bx < lp-1 {
                    a[bx], a[lp-1] = a[lp-1], b
                }
                up = lp - 2
            } else {
                if bx > lp {
                    a[bx], a[lp] = a[lp], b
                }
                up = lp - 1
                lp++
            }
            if up-lower < upper-lp {
                pex(lower, up)
                lower = lp
            } else {
                pex(lp, upper)
                upper = up
            }
        }
    }
    pex(0, len(a)-1)
}

// Step 2.0 sequence routines.  2.0 is the easy part.  2.5, timings, follows.

func ones(n int) []int {
    s := make([]int, n)
    for i := range s {
        s[i] = 1
    }
    return s
}

func ascending(n int) []int {
    s := make([]int, n)
    v := 1
    for i := 0; i < n; {
        if rand.Intn(3) == 0 {
            s[i] = v
            i++
        }
        v++
    }
    return s
}

func shuffled(n int) []int {
    return rand.Perm(n)
}

// Steps 2.5 write timings, and 3 plot timings are coded together.
// If write means format and output human readable numbers, step 2.5
// is satisfied with the log output as the program runs.  The timings
// are plotted immediately however for step 3, not read and parsed from
// any formated output.
const (
    nPts = 7    // number of points per test
    inc  = 1000 // data set size increment per point
)

var (
    p        *plot.Plot
    sortName = []string{"Bubble sort", "Insertion sort", "Quicksort"}
    sortFunc = []func([]int){bubblesort, insertionsort, quicksort}
    dataName = []string{"Ones", "Ascending", "Shuffled"}
    dataFunc = []func(int) []int{ones, ascending, shuffled}
)

func main() {
    rand.Seed(time.Now().Unix())
    var err error
    p, err = plot.New()
    if err != nil {
        log.Fatal(err)
    }
    p.X.Label.Text = "Data size"
    p.Y.Label.Text = "microseconds"
    p.Y.Scale = plot.LogScale{}
    p.Y.Tick.Marker = plot.LogTicks{}
    p.Y.Min = .5 // hard coded to make enough room for legend

    for dx, name := range dataName {
        s, err := plotter.NewScatter(plotter.XYs{})
        if err != nil {
            log.Fatal(err)
        }
        s.Shape = plotutil.DefaultGlyphShapes[dx]
        p.Legend.Add(name, s)
    }
    for sx, name := range sortName {
        l, err := plotter.NewLine(plotter.XYs{})
        if err != nil {
            log.Fatal(err)
        }
        l.Color = plotutil.DarkColors[sx]
        p.Legend.Add(name, l)
    }
    for sx := range sortFunc {
        bench(sx, 0, 1) // for ones, a single timing is sufficient.
        bench(sx, 1, 5) // ascending and shuffled have some randomness though,
        bench(sx, 2, 5) // so average timings on 5 different random sets.
    }

    if err := p.Save(5*vg.Inch, 5*vg.Inch, "comp.png"); err != nil {
        log.Fatal(err)
    }
}

func bench(sx, dx, rep int) {
    log.Println("bench", sortName[sx], dataName[dx], "x", rep)
    pts := make(plotter.XYs, nPts)
    sf := sortFunc[sx]
    for i := range pts {
        x := (i + 1) * inc
        // to avoid timing sequence creation, create sequence before timing
        // then just copy the data inside the timing loop.  copy time should
        // be the same regardless of sequence data.
        s0 := dataFunc[dx](x) // reference sequence
        s := make([]int, x)   // working copy
        var tSort int64
        for j := 0; j < rep; j++ {
            tSort += testing.Benchmark(func(b *testing.B) {
                for i := 0; i < b.N; i++ {
                    copy(s, s0)
                    sf(s)
                }
            }).NsPerOp()
        }
        tSort /= int64(rep)
        log.Println(x, "items", tSort, "ns") // step 2.5, write timings
        pts[i] = struct{ X, Y float64 }{float64(x), float64(tSort) * .001}
    }
    pl, ps, err := plotter.NewLinePoints(pts) // step 3, plot timings
    if err != nil {
        log.Fatal(err)
    }
    pl.Color = plotutil.DarkColors[sx]
    ps.Color = plotutil.DarkColors[sx]
    ps.Shape = plotutil.DefaultGlyphShapes[dx]
    p.Add(pl, ps)
}
