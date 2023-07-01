package main

import (
	"bytes"
	"fmt"
	"image"
	"image/color"
	"image/draw"
	"image/png"
)

func main() {
	// A rectangle from 0,0 to 300,240.
	r := image.Rect(0, 0, 300, 240)

	// Create an image
	im := image.NewNRGBA(r)

	// set some color variables for convience
	var (
		red  = color.RGBA{0xff, 0x00, 0x00, 0xff}
		blue = color.RGBA{0x00, 0x00, 0xff, 0xff}
	)

	// Fill with a uniform color
	draw.Draw(im, r, &image.Uniform{red}, image.ZP, draw.Src)

	// Set individual pixels
	im.Set(10, 20, blue)
	im.Set(20, 30, color.Black)
	im.Set(30, 40, color.RGBA{0x10, 0x20, 0x30, 0xff})

	// Get the values of specific pixels as color.Color types.
	// The color will be in the color.Model of the image (in this
	// case color.NRGBA) but color models can convert their values
	// to other models.
	c1 := im.At(0, 0)
	c2 := im.At(10, 20)

	// or directly as RGB components (scaled values)
	redc, greenc, bluec, _ := c1.RGBA()
	redc, greenc, bluec, _ = im.At(30, 40).RGBA()

	// Images can be read and writen in various formats
	var buf bytes.Buffer
	err := png.Encode(&buf, im)
	if err != nil {
		fmt.Println(err)
	}

	fmt.Println("Image size:", im.Bounds().Dx(), "×", im.Bounds().Dy())
	fmt.Println(buf.Len(), "bytes when encoded as PNG.")
	fmt.Printf("Pixel at %7v is %v\n", image.Pt(0, 0), c1)
	fmt.Printf("Pixel at %7v is %#v\n", image.Pt(10, 20), c2) // %#v shows type details
	fmt.Printf("Pixel at %7v has R=%d, G=%d, B=%d\n",
		image.Pt(30, 40), redc, greenc, bluec)
}
