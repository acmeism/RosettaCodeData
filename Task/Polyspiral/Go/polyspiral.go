package main

import (
    "image"
    "image/color"
    "image/gif"
    "log"
    "math"
    "os"
)

func drawLine(img *image.Paletted, x1, y1, x2, y2 int, ci uint8) {
    var first, last int
    if x2 != x1 {
        m := float64(y2-y1) / float64(x2-x1)
        if x1 < x2 {
            first, last = x1, x2
        } else {
            first, last = x2, x1
        }
        for x := first; x <= last; x++ {
            y := int(m*float64(x-x1)+0.5) + y1
            img.SetColorIndex(x, y, ci)
        }
    } else {
        if y1 < y2 {
            first, last = y1, y2
        } else {
            first, last = y2, y1
        }
        for y := first; y <= last; y++ {
            img.SetColorIndex(x1, y, ci)
        }
    }
}

func setBackgroundColor(img *image.Paletted, w, h int, ci uint8) {
    for x := 0; x < w; x++ {
        for y := 0; y < h; y++ {
            img.SetColorIndex(x, y, ci)
        }
    }
}

func hsb2rgb(hue, sat, bri float64) (r, g, b int) {
    u := int(bri*255 + 0.5)
    if sat == 0 {
        r, g, b = u, u, u
    } else {
        h := (hue - math.Floor(hue)) * 6
        f := h - math.Floor(h)
        p := int(bri*(1-sat)*255 + 0.5)
        q := int(bri*(1-sat*f)*255 + 0.5)
        t := int(bri*(1-sat*(1-f))*255 + 0.5)
        switch int(h) {
        case 0:
            r, g, b = u, t, p
        case 1:
            r, g, b = q, u, p
        case 2:
            r, g, b = p, u, t
        case 3:
            r, g, b = p, q, u
        case 4:
            r, g, b = t, p, u
        case 5:
            r, g, b = u, p, q
        }
    }
    return
}

func main() {
    const degToRad = math.Pi / 180
    const nframes = 360
    const delay = 20 // 200ms
    width, height := 640, 640
    anim := gif.GIF{LoopCount: nframes}
    rect := image.Rect(0, 0, width, height)
    palette := make([]color.Color, 151)
    palette[0] = color.White
    for i := 1; i <= 150; i++ {
        r, g, b := hsb2rgb(float64(i)/150, 1, 1)
        palette[i] = color.RGBA{uint8(r), uint8(g), uint8(b), 255}
    }
    incr := 0
    for f := 1; f <= nframes; f++ {
        incr = (incr + 1) % 360
        x1, y1 := width/2, height/2
        length := 5.0
        img := image.NewPaletted(rect, palette)
        setBackgroundColor(img, width, height, 0) // white background
        angle := incr
        for ci := uint8(1); ci <= 150; ci++ {
            x2 := x1 + int(math.Cos(float64(angle)*degToRad)*length)
            y2 := y1 - int(math.Sin(float64(angle)*degToRad)*length)
            drawLine(img, x1, y1, x2, y2, ci)
            x1, y1 = x2, y2
            length += 3
            angle = (angle + incr) % 360
        }
        anim.Delay = append(anim.Delay, delay)
        anim.Image = append(anim.Image, img)
    }
    file, err := os.Create("polyspiral.gif")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    if err2 := gif.EncodeAll(file, &anim); err != nil {
        log.Fatal(err2)
    }
}
