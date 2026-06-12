package main

import (
    "github.com/fogleman/gg"
    "math"
)

type tiletype int

const (
    kite tiletype = iota
    dart
)

type tile struct {
    tt          tiletype
    x, y        float64
    angle, size float64
}

var gr = (1 + math.Sqrt(5)) / 2 // golden ratio

const theta = math.Pi / 5 // 36 degrees in radians

func setupPrototiles(w, h int) []tile {
    var proto []tile
    // sun
    for a := math.Pi/2 + theta; a < 3*math.Pi; a += 2 * theta {
        ww := float64(w / 2)
        hh := float64(h / 2)
        proto = append(proto, tile{kite, ww, hh, a, float64(w) / 2.5})
    }
    return proto
}

func distinctTiles(tls []tile) []tile {
    tileset := make(map[tile]bool)
    for _, tl := range tls {
        tileset[tl] = true
    }
    distinct := make([]tile, len(tileset))
    for tl, _ := range tileset {
        distinct = append(distinct, tl)
    }
    return distinct
}

func deflateTiles(tls []tile, gen int) []tile {
    if gen <= 0 {
        return tls
    }
    var next []tile
    for _, tl := range tls {
        x, y, a, size := tl.x, tl.y, tl.angle, tl.size/gr
        var nx, ny float64
        if tl.tt == dart {
            next = append(next, tile{kite, x, y, a + 5*theta, size})
            for i, sign := 0, 1.0; i < 2; i, sign = i+1, -sign {
                nx = x + math.Cos(a-4*theta*sign)*gr*tl.size
                ny = y - math.Sin(a-4*theta*sign)*gr*tl.size
                next = append(next, tile{dart, nx, ny, a - 4*theta*sign, size})
            }
        } else {
            for i, sign := 0, 1.0; i < 2; i, sign = i+1, -sign {
                next = append(next, tile{dart, x, y, a - 4*theta*sign, size})
                nx = x + math.Cos(a-theta*sign)*gr*tl.size
                ny = y - math.Sin(a-theta*sign)*gr*tl.size
                next = append(next, tile{kite, nx, ny, a + 3*theta*sign, size})
            }
        }
    }
    // remove duplicates
    tls = distinctTiles(next)
    return deflateTiles(tls, gen-1)
}

func drawTiles(dc *gg.Context, tls []tile) {
    dist := [2][3]float64{{gr, gr, gr}, {-gr, -1, -gr}}
    for _, tl := range tls {
        angle := tl.angle - theta
        dc.MoveTo(tl.x, tl.y)
        ord := tl.tt
        for i := 0; i < 3; i++ {
            x := tl.x + dist[ord][i]*tl.size*math.Cos(angle)
            y := tl.y - dist[ord][i]*tl.size*math.Sin(angle)
            dc.LineTo(x, y)
            angle += theta
        }
        dc.ClosePath()
        if ord == kite {
            dc.SetHexColor("FFA500") // orange
        } else {
            dc.SetHexColor("FFFF00") // yellow
        }
        dc.FillPreserve()
        dc.SetHexColor("A9A9A9") // dark gray
        dc.SetLineWidth(1)
        dc.Stroke()
    }
}

func main() {
    w, h := 700, 450
    dc := gg.NewContext(w, h)
    dc.SetRGB(1, 1, 1)
    dc.Clear()
    tiles := deflateTiles(setupPrototiles(w, h), 5)
    drawTiles(dc, tiles)
    dc.SavePNG("penrose_tiling.png")
}
