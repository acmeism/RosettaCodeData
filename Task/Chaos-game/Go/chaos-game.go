package main

import (
	"fmt"
	"image"
	"image/color"
	"image/draw"
	"image/gif"
	"log"
	"math"
	"math/rand"
	"os"
	"time"
)

var bwPalette = color.Palette{
	color.Transparent,
	color.White,
	color.RGBA{R: 0xff, A: 0xff},
	color.RGBA{G: 0xff, A: 0xff},
	color.RGBA{B: 0xff, A: 0xff},
}

func main() {
	const (
		width          = 160
		frames         = 100
		pointsPerFrame = 50
		delay          = 100 * time.Millisecond
		filename       = "chaos_anim.gif"
	)

	var tan60 = math.Sin(math.Pi / 3)
	height := int(math.Round(float64(width) * tan60))
	b := image.Rect(0, 0, width, height)
	vertices := [...]image.Point{
		{0, height}, {width, height}, {width / 2, 0},
	}

	// Make a filled triangle.
	m := image.NewPaletted(b, bwPalette)
	for y := b.Min.Y; y < b.Max.Y; y++ {
		bg := int(math.Round(float64(b.Max.Y-y) / 2 / tan60))
		for x := b.Min.X + bg; x < b.Max.X-bg; x++ {
			m.SetColorIndex(x, y, 1)
		}
	}

	// Pick starting point
	var p image.Point
	rand.Seed(time.Now().UnixNano())
	p.Y = rand.Intn(height) + b.Min.Y
	p.X = rand.Intn(width) + b.Min.X // TODO: make within triangle

	anim := newAnim(frames, delay)
	addFrame(anim, m)
	for i := 1; i < frames; i++ {
		for j := 0; j < pointsPerFrame; j++ {
			// Pick a random vertex
			vi := rand.Intn(len(vertices))
			v := vertices[vi]
			// Move p halfway there
			p.X = (p.X + v.X) / 2
			p.Y = (p.Y + v.Y) / 2
			m.SetColorIndex(p.X, p.Y, uint8(2+vi))
		}
		addFrame(anim, m)
	}
	if err := writeAnim(anim, filename); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("wrote to %q\n", filename)
}

// Stuff for making a simple GIF animation.

func newAnim(frames int, delay time.Duration) *gif.GIF {
	const gifDelayScale = 10 * time.Millisecond
	g := &gif.GIF{
		Image: make([]*image.Paletted, 0, frames),
		Delay: make([]int, 1, frames),
	}
	g.Delay[0] = int(delay / gifDelayScale)
	return g
}
func addFrame(anim *gif.GIF, m *image.Paletted) {
	b := m.Bounds()
	dst := image.NewPaletted(b, m.Palette)
	draw.Draw(dst, b, m, image.ZP, draw.Src)
	anim.Image = append(anim.Image, dst)
	if len(anim.Delay) < len(anim.Image) {
		anim.Delay = append(anim.Delay, anim.Delay[0])
	}
}
func writeAnim(anim *gif.GIF, filename string) error {
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	err = gif.EncodeAll(f, anim)
	if cerr := f.Close(); err == nil {
		err = cerr
	}
	return err
}
