package main

import (
    "fmt"
    "image"
    "image/color"
    "image/png"
    "math/rand"
    "os"
)

const w = 400     // image width
const h = 300     // image height
const n = 15000   // number of particles to add
const frost = 255 // white

var g *image.Gray

func main() {
    g = image.NewGray(image.Rectangle{image.Point{0, 0}, image.Point{w, h}})
    // off center seed position makes pleasingly asymetrical tree
    g.SetGray(w/3, h/3, color.Gray{frost})
generate:
    for a := 0; a < n; {
        // generate random position for new particle
        rp := image.Point{rand.Intn(w), rand.Intn(h)}
        if g.At(rp.X, rp.Y).(color.Gray).Y == frost {
            // position is already set.  find a nearby free position.
            for {
                rp.X += rand.Intn(3) - 1
                rp.Y += rand.Intn(3) - 1
                // execpt if we run out of bounds, consider the particle lost.
                if !rp.In(g.Rect) {
                    continue generate
                }
                if g.At(rp.X, rp.Y).(color.Gray).Y != frost {
                    break
                }
            }
        } else {
            // else particle is in free space.  let it wander
            // until it touches tree
            for !hasNeighbor(rp) {
                rp.X += rand.Intn(3) - 1
                rp.Y += rand.Intn(3) - 1
                // but again, if it wanders out of bounds consider it lost.
                if !rp.In(g.Rect) {
                    continue generate
                }
            }
        }
        // x, y now specify a free position toucing the tree.
        g.SetGray(rp.X, rp.Y, color.Gray{frost})
        a++
        // progress indicator
        if a%100 == 0 {
            fmt.Println(a, "of", n)
        }
    }
    f, err := os.Create("tree.png")
    if err != nil {
        fmt.Println(err)
        return
    }
    err = png.Encode(f, g)
    if err != nil {
        fmt.Println(err)
    }
    f.Close()
}

var n8 = []image.Point{
    {-1, -1}, {-1, 0}, {-1, 1},
    {0, -1}, {0, 1},
    {1, -1}, {1, 0}, {1, 1}}

func hasNeighbor(p image.Point) bool {
    for _, n := range n8 {
        o := p.Add(n)
        if o.In(g.Rect) && g.At(o.X, o.Y).(color.Gray).Y == frost {
            return true
        }
    }
    return false
}
