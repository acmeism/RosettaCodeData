package main

import (
    "image"
    "image/png"
    "os"
)

func main() {
    g := image.NewGray(image.Rect(0, 0, 256, 256))
    for i := range g.Pix {
        g.Pix[i] = uint8(i>>8 ^ i)
    }
    f, _ := os.Create("xor.png")
    png.Encode(f, g)
    f.Close()
}
