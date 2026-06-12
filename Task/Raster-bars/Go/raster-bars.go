package main

import (
    "image"
    "image/color"
    "image/gif"
    "log"
    "os"
)

var (
    c0 = color.RGBA{166, 124, 0, 255}
    c1 = color.RGBA{191, 155, 48, 255}
    c2 = color.RGBA{255, 191, 0, 255}
    c3 = color.RGBA{255, 207, 64, 255}
    c4 = color.RGBA{255, 220, 115, 255}
)

var palette = []color.Color{c0, c1, c2, c3, c4}

func hline(img *image.Paletted, x1, y, x2 int, ci uint8) {
    for ; x1 <= x2; x1++ {
        img.SetColorIndex(x1, y, ci)
    }
}

func vline(img *image.Paletted, x, y1, y2 int, ci uint8) {
    for ; y1 <= y2; y1++ {
        img.SetColorIndex(x, y1, ci)
    }
}

func drawHbar(img *image.Paletted, x1, y1, x2, y2 int, ci uint8) {
    for ; y1 <= y2; y1++ {
        hline(img, x1, y1, x2, ci)
    }
}

func drawVbar(img *image.Paletted, x1, y1, x2, y2 int, ci uint8) {
    for ; x1 <= x2; x1++ {
        vline(img, x1, y1, y2, ci)
    }
}

func main() {
    const nframes = 40
    const delay = 15 // 150ms
    width, height := 500, 500
    anim := gif.GIF{LoopCount: 9} // repeats 9 + 1 times
    rect := image.Rect(0, 0, width, height)

    for f := 0; f < nframes; f++ {
        img := image.NewPaletted(rect, palette)
        c := uint8(f % 2)
        if f < nframes/2 {
            for y := 0; y < height; y += 20 {
                drawHbar(img, 0, y, width, y+19, c)
                c++
                if c == 5 {
                    c = 0
                }
            }
        } else {
            for x := 0; x < width; x += 20 {
                drawVbar(img, x, 0, x+19, height, c)
                c++
                if c == 5 {
                    c = 0
                }
            }
        }
        anim.Delay = append(anim.Delay, delay)
        anim.Image = append(anim.Image, img)
    }

    file, err := os.Create("raster_bars.gif")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    if err2 := gif.EncodeAll(file, &anim); err != nil {
        log.Fatal(err2)
    }
}
