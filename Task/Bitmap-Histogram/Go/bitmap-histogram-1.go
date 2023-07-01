package raster

import "math"

func (g *Grmap) Histogram(bins int) []int {
    if bins <= 0 {
        bins = g.cols
    }
    h := make([]int, bins)
    for _, p := range g.px {
        h[int(p)*(bins-1)/math.MaxUint16]++
    }
    return h
}

func (g *Grmap) Threshold(t uint16) {
    for i, p := range g.px {
        if p < t {
            g.px[i] = 0
        } else {
            g.px[i] = math.MaxUint16
        }
    }
}
