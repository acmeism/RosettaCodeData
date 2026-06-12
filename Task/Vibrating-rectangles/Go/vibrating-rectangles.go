package main

import (
    "image"
    "image/color"
    "image/gif"
    "log"
    "os"
)

var (
    black   = color.RGBA{0, 0, 0, 255}
    red     = color.RGBA{255, 0, 0, 255}
    green   = color.RGBA{0, 255, 0, 255}
    blue    = color.RGBA{0, 0, 255, 255}
    magenta = color.RGBA{255, 0, 255, 255}
    cyan    = color.RGBA{0, 255, 255, 255}
    yellow  = color.RGBA{255, 255, 0, 255}
    white   = color.RGBA{255, 255, 255, 255}
)

var palette = []color.Color{red, green, blue, magenta, cyan, yellow, white, black}

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

func setBackgroundColor(img *image.Paletted, w, h int, ci uint8) {
    for x := 0; x < w; x++ {
        for y := 0; y < h; y++ {
            img.SetColorIndex(x, y, ci)
        }
    }
}

func drawRectangle(img *image.Paletted, x1, y1, x2, y2 int, ci uint8) {
    hline(img, x1, y1, x2, ci)
    hline(img, x1, y2, x2, ci)
    vline(img, x1, y1, y2, ci)
    vline(img, x2, y1, y2, ci)
}

func main() {
    const nframes = 140
    const delay = 10 // 100ms
    width, height := 500, 500
    anim := gif.GIF{LoopCount: nframes}
    rect := image.Rect(0, 0, width, height)
    for c := uint8(0); c < 7; c++ {
        for f := 0; f < 20; f++ {
            img := image.NewPaletted(rect, palette)
            setBackgroundColor(img, width, height, 7) // black background
            for r := 0; r < 20; r++ {
                ix := c
                if r < f {
                    ix = (ix + 1) % 7
                }
                x := width * (r + 1) / 50
                y := height * (r + 1) / 50
                w := width - x
                h := height - y
                drawRectangle(img, x, y, w, h, ix)
            }
            anim.Delay = append(anim.Delay, delay)
            anim.Image = append(anim.Image, img)
        }
    }
    file, err := os.Create("vibrating.gif")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    if err2 := gif.EncodeAll(file, &anim); err != nil {
        log.Fatal(err2)
    }
}
