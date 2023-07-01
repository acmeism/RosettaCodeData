package main

import (
    "fmt"
    "image"
    "image/color"
    "image/draw"
    "image/png"
    "math/cmplx"
    "os"
)

const (
    maxEsc = 100
    rMin   = -2.
    rMax   = .5
    iMin   = -1.
    iMax   = 1.
    width  = 750
    red    = 230
    green  = 235
    blue   = 255
)

func mandelbrot(a complex128) float64 {
    i := 0
    for z := a; cmplx.Abs(z) < 2 && i < maxEsc; i++ {
        z = z*z + a
    }
    return float64(maxEsc-i) / maxEsc
}

func main() {
    scale := width / (rMax - rMin)
    height := int(scale * (iMax - iMin))
    bounds := image.Rect(0, 0, width, height)
    b := image.NewNRGBA(bounds)
    draw.Draw(b, bounds, image.NewUniform(color.Black), image.ZP, draw.Src)
    for x := 0; x < width; x++ {
        for y := 0; y < height; y++ {
            fEsc := mandelbrot(complex(
                float64(x)/scale+rMin,
                float64(y)/scale+iMin))
            b.Set(x, y, color.NRGBA{uint8(red * fEsc),
                uint8(green * fEsc), uint8(blue * fEsc), 255})

        }
    }
    f, err := os.Create("mandelbrot.png")
    if err != nil {
        fmt.Println(err)
        return
    }
    if err = png.Encode(f, b); err != nil {
        fmt.Println(err)
    }
    if err = f.Close(); err != nil {
        fmt.Println(err)
    }
}
