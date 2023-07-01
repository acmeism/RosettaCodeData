package main

import (
    "fmt"
    "image"
    "image/color"
    "image/draw"
)

func main() {
    rect := image.Rect(0, 0, 320, 240)
    img := image.NewRGBA(rect)

    // Use green background, say.
    green := color.RGBA{0, 255, 0, 255}
    draw.Draw(img, rect, &image.Uniform{green}, image.ZP, draw.Src)

    // Set color of pixel at (100, 100) to red
    red := color.RGBA{255, 0, 0, 255}
    img.Set(100, 100, red)

    // Check it worked.
    cmap := map[color.Color]string{green: "green", red: "red"}
    c1 := img.At(0, 0)
    c2 := img.At(100, 100)
    fmt.Println("The color of the pixel at (  0,   0) is", cmap[c1], "\b.")
    fmt.Println("The color of the pixel at (100, 100) is", cmap[c2], "\b.")
}
