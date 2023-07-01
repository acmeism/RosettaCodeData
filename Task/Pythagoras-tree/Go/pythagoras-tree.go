package main

import (
	"image"
	"image/color"
	"image/draw"
	"image/png"
	"log"
	"os"
)

const (
	width, height = 800, 600
	maxDepth      = 11                    // how far to recurse, between 1 and 20 is reasonable
	colFactor     = uint8(255 / maxDepth) // adjusts the colour so leaves get greener further out
	fileName      = "pythagorasTree.png"
)

func main() {
	img := image.NewNRGBA(image.Rect(0, 0, width, height)) // create new image
	bg := image.NewUniform(color.RGBA{255, 255, 255, 255}) // prepare white for background
	draw.Draw(img, img.Bounds(), bg, image.ZP, draw.Src)   // fill the background

	drawSquares(340, 550, 460, 550, img, 0) // start off near the bottom of the image

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

func drawSquares(ax, ay, bx, by int, img *image.NRGBA, depth int) {
	if depth > maxDepth {
		return
	}
	dx, dy := bx-ax, ay-by
	x3, y3 := bx-dy, by-dx
	x4, y4 := ax-dy, ay-dx
	x5, y5 := x4+(dx-dy)/2, y4-(dx+dy)/2
	col := color.RGBA{0, uint8(depth) * colFactor, 0, 255}
	drawLine(ax, ay, bx, by, img, col)
	drawLine(bx, by, x3, y3, img, col)
	drawLine(x3, y3, x4, y4, img, col)
	drawLine(x4, y4, ax, ay, img, col)
	drawSquares(x4, y4, x5, y5, img, depth+1)
	drawSquares(x5, y5, x3, y3, img, depth+1)
}

func drawLine(x0, y0, x1, y1 int, img *image.NRGBA, col color.RGBA) {
	dx := abs(x1 - x0)
	dy := abs(y1 - y0)
	var sx, sy int = -1, -1
	if x0 < x1 {
		sx = 1
	}
	if y0 < y1 {
		sy = 1
	}
	err := dx - dy
	for {
		img.Set(x0, y0, col)
		if x0 == x1 && y0 == y1 {
			break
		}
		e2 := 2 * err
		if e2 > -dy {
			err -= dy
			x0 += sx
		}
		if e2 < dx {
			err += dx
			y0 += sy
		}
	}
}
func abs(x int) int {
	if x < 0 {
		return -x
	}
	return x
}
