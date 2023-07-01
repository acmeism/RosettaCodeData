package main

import (
	"image"
	"image/color"
	"image/draw"
	"image/png"
	"log"
	"math"
	"os"
)

func main() {
	const (
		width, height = 600, 600
		centre        = width / 2.0
		degreesIncr   = 0.1 * math.Pi / 180
		turns         = 2
		stop          = 360 * turns * 10 * degreesIncr
		fileName      = "spiral.png"
	)

	img := image.NewNRGBA(image.Rect(0, 0, width, height)) // create new image
	bg := image.NewUniform(color.RGBA{255, 255, 255, 255}) // prepare white for background
	draw.Draw(img, img.Bounds(), bg, image.ZP, draw.Src)   // fill the background
	fgCol := color.RGBA{255, 0, 0, 255}                    // red plot

	a := 1.0
	b := 20.0

	for theta := 0.0; theta < stop; theta += degreesIncr {
		r := a + b*theta
		x := r * math.Cos(theta)
		y := r * math.Sin(theta)
		img.Set(int(centre+x), int(centre-y), fgCol)
	}

	imgFile, err := os.Create(fileName)
	if err != nil {
		log.Fatal(err)
	}
	defer imgFile.Close()

	if err := png.Encode(imgFile, img); err != nil {
		imgFile.Close()
		log.Fatal(err)
	}
}
