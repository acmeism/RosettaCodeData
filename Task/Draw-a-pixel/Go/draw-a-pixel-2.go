package main

import (
	"image"
	"image/color"
	"image/draw"
	"image/png"
	"os"
)

func main() {
	// Create a 320 x 240 image
	img := image.NewRGBA(image.Rect(0, 0, 320, 240))
	// fill img in white
	draw.Draw(img, img.Bounds(), &image.Uniform{color.RGBA{0, 0, 0, 0}}, image.ZP, draw.Src)
	// Draw a red dot at (100, 100)
	img.Set(100, 100, color.RGBA{255, 0, 0, 255})
	// Save to new.png
	w, _ := os.OpenFile("new.png", os.O_WRONLY|os.O_CREATE, 0600)
	defer w.Close()
	png.Encode(w, img)
}
