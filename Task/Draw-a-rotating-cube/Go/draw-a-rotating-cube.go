package main

import (
	"image"
	"image/color"
	"image/gif"
	"log"
	"math"
	"os"
)

const (
	width, height = 640, 640
	offset        = height / 2
	fileName      = "rotatingCube.gif"
)

var nodes = [][]float64{{-100, -100, -100}, {-100, -100, 100}, {-100, 100, -100}, {-100, 100, 100},
	{100, -100, -100}, {100, -100, 100}, {100, 100, -100}, {100, 100, 100}}
var edges = [][]int{{0, 1}, {1, 3}, {3, 2}, {2, 0}, {4, 5}, {5, 7}, {7, 6},
	{6, 4}, {0, 4}, {1, 5}, {2, 6}, {3, 7}}

func main() {
	var images []*image.Paletted
	fgCol := color.RGBA{0xff, 0x00, 0xff, 0xff}
	var palette = []color.Color{color.RGBA{0x00, 0x00, 0x00, 0xff}, fgCol}
	var delays []int

	imgFile, err := os.Create(fileName)
	if err != nil {
		log.Fatal(err)
	}
	defer imgFile.Close()

	rotateCube(math.Pi/4, math.Atan(math.Sqrt(2)))
	var frame float64
	for frame = 0; frame < 360; frame++ {
		img := image.NewPaletted(image.Rect(0, 0, width, height), palette)
		images = append(images, img)
		delays = append(delays, 5)
		for _, edge := range edges {
			xy1 := nodes[edge[0]]
			xy2 := nodes[edge[1]]
			drawLine(int(xy1[0])+offset, int(xy1[1])+offset, int(xy2[0])+offset, int(xy2[1])+offset, img, fgCol)
		}
		rotateCube(math.Pi/180, 0)
	}
	if err := gif.EncodeAll(imgFile, &gif.GIF{Image: images, Delay: delays}); err != nil {
		imgFile.Close()
		log.Fatal(err)
	}

}

func rotateCube(angleX, angleY float64) {
	sinX := math.Sin(angleX)
	cosX := math.Cos(angleX)
	sinY := math.Sin(angleY)
	cosY := math.Cos(angleY)
	for _, node := range nodes {
		x := node[0]
		y := node[1]
		z := node[2]
		node[0] = x*cosX - z*sinX
		node[2] = z*cosX + x*sinX
		z = node[2]
		node[1] = y*cosY - z*sinY
		node[2] = z*cosY + y*sinY
	}
}

func drawLine(x0, y0, x1, y1 int, img *image.Paletted, col color.RGBA) {
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
