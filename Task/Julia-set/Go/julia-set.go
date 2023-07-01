package main

import (
	"image"
	"image/color"
	"image/png"
	"log"
	"os"
	"sync"
)

func main() {
	const (
		width, height = 800.0, 600.0
		maxIter       = 255
		cX, cY        = -0.7, 0.27015
		fileName      = "julia.png"
	)
	img := image.NewNRGBA(image.Rect(0, 0, width, height))

	var wg sync.WaitGroup
	wg.Add(width)
	for x := 0; x < width; x++ {
		thisx := float64(x)
		go func() {
			var tmp, zx, zy float64
			var i uint8
			for y := 0.0; y < height; y++ {
				zx = 1.5 * (thisx - width/2) / (0.5 * width)
				zy = (y - height/2) / (0.5 * height)
				i = maxIter
				for zx*zx+zy*zy < 4.0 && i > 0 {
					tmp = zx*zx - zy*zy + cX
					zy = 2.0*zx*zy + cY
					zx = tmp
					i--
				}
				img.Set(int(thisx), int(y), color.RGBA{i, i, i << 3, 255})
			}
			wg.Done()
		}()
	}
	wg.Wait()
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
