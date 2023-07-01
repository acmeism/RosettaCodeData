package main

import (
    "log"

    "github.com/gonum/plot"
    "github.com/gonum/plot/plotter"
    "github.com/gonum/plot/plotutil"
    "github.com/gonum/plot/vg"
)

var (
    x = []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
    y = []float64{2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0}
)

func main() {
    pts := make(plotter.XYs, len(x))
    for i, xi := range x {
        pts[i] = struct{ X, Y float64 }{float64(xi), y[i]}
    }
    p, err := plot.New()
    if err != nil {
        log.Fatal(err)
    }
    if err = plotutil.AddScatters(p, pts); err != nil {
        log.Fatal(err)
    }
    if err := p.Save(3*vg.Inch, 3*vg.Inch, "points.svg"); err != nil {
        log.Fatal(err)
    }
}
