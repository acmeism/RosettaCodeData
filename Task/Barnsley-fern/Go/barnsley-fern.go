package main

import (
    "image"
    "image/color"
    "image/draw"
    "image/png"
    "log"
    "math/rand"
    "os"
)

// values from WP
const (
    xMin = -2.1820
    xMax = 2.6558
    yMin = 0.
    yMax = 9.9983
)

// parameters
var (
    width = 200
    n     = int(1e6)
    c     = color.RGBA{34, 139, 34, 255} // forest green
)

func main() {
    dx := xMax - xMin
    dy := yMax - yMin
    fw := float64(width)
    fh := fw * dy / dx
    height := int(fh)
    r := image.Rect(0, 0, width, height)
    img := image.NewRGBA(r)
    draw.Draw(img, r, &image.Uniform{color.White}, image.ZP, draw.Src)
    var x, y float64
    plot := func() {
        // transform computed float x, y to integer image coordinates
        ix := int(fw * (x - xMin) / dx)
        iy := int(fh * (yMax - y) / dy)
        img.SetRGBA(ix, iy, c)
    }
    plot()
    for i := 0; i < n; i++ {
        switch s := rand.Intn(100); {
        case s < 85:
            x, y =
                .85*x+.04*y,
                -.04*x+.85*y+1.6
        case s < 85+7:
            x, y =
                .2*x-.26*y,
                .23*x+.22*y+1.6
        case s < 85+7+7:
            x, y =
                -.15*x+.28*y,
                .26*x+.24*y+.44
        default:
            x, y = 0, .16*y
        }
        plot()
    }
    // write img to png file
    f, err := os.Create("bf.png")
    if err != nil {
        log.Fatal(err)
    }
    if err := png.Encode(f, img); err != nil {
        log.Fatal(err)
    }
}
