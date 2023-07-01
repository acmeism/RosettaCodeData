package main

// Files required to build supporting package raster are found in:
// * Bitmap
// * Grayscale image
// * Write a PPM file

import (
    "fmt"
    "math/rand"
    "raster"
)

const w = 400       // image width
const h = 300       // image height
const n = 15000     // number of particles to add
const frost = 65535 // white

var g *raster.Grmap

func main() {
    g = raster.NewGrmap(w, h)
    // off center seed position makes pleasingly asymetrical tree
    g.SetPx(w/3, h/3, frost)
    var x, y int
generate:
    for a := 0; a < n; {
        // generate random position for new particle
        x, y = rand.Intn(w), rand.Intn(h)
        switch p, ok := g.GetPx(x, y); p {
        case frost:
            // position is already set.  find a nearby free position.
            for p == frost {
                x += rand.Intn(3) - 1
                y += rand.Intn(3) - 1
                p, ok = g.GetPx(x, y)

                // execpt if we run out of bounds, consider the particle lost.
                if !ok {
                    continue generate
                }
            }
        default:
            // else particle is in free space.  let it wander
            // until it touches tree
            for !hasNeighbor(x, y) {
                x += rand.Intn(3) - 1
                y += rand.Intn(3) - 1
                // but again, if it wanders out of bounds consider it lost.
                _, ok = g.GetPx(x, y)
                if !ok {
                    continue generate
                }
            }
        }
        // x, y now specify a free position toucing the tree.
        g.SetPx(x, y, frost)
        a++
        // progress indicator
        if a%100 == 0 {
            fmt.Println(a, "of", n)
        }
    }
    g.Bitmap().WritePpmFile("tree.ppm")
}

var n8 = [][]int{
    {-1, -1}, {-1, 0}, {-1, 1},
    { 0, -1},          { 0, 1},
    { 1, -1}, { 1, 0}, { 1, 1}}

func hasNeighbor(x, y int) bool {
    for _, n := range n8 {
        if p, ok := g.GetPx(x+n[0], y+n[1]); ok && p == frost {
            return true
        }
    }
    return false
}
