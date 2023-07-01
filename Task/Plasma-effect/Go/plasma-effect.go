package main

import (
    "image"
    "image/color"
    "image/gif"
    "log"
    "math"
    "os"
)

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
    const nframes = 100
    const delay = 4 // 40ms
    w, h := 640, 640
    anim := gif.GIF{LoopCount: nframes}
    rect := image.Rect(0, 0, w, h)
    palette := make([]color.Color, nframes+1)
    palette[0] = color.White
    for i := 1; i <= nframes; i++ {
        r, g, b := hsb2rgb(float64(i)/nframes, 1, 1)
        palette[i] = color.RGBA{uint8(r), uint8(g), uint8(b), 255}
    }
    for f := 1; f <= nframes; f++ {
        img := image.NewPaletted(rect, palette)
        setBackgroundColor(img, w, h, 0) // white background
        for y := 0; y < h; y++ {
            for x := 0; x < w; x++ {
                fx, fy := float64(x), float64(y)
                value := math.Sin(fx / 16)
                value += math.Sin(fy / 8)
                value += math.Sin((fx + fy) / 16)
                value += math.Sin(math.Sqrt(fx*fx+fy*fy) / 8)
                value += 4 // shift range from [-4, 4] to [0, 8]
                value /= 8 // bring range down to [0, 1]
                _, rem := math.Modf(value + float64(f)/float64(nframes))
                ci := uint8(nframes*rem) + 1
                img.SetColorIndex(x, y, ci)
            }
        }
        anim.Delay = append(anim.Delay, delay)
        anim.Image = append(anim.Image, img)
    }
    file, err := os.Create("plasma.gif")
    if err != nil {
        log.Fatal(err)
    }
    defer file.Close()
    if err2 := gif.EncodeAll(file, &anim); err != nil {
        log.Fatal(err2)
    }
}
