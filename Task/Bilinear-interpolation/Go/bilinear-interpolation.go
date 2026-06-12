package main

import (
	"image"
	"image/color"
	"image/jpeg"
	"log"
	"math"
	"os"

	"golang.org/x/image/draw"
)

func scale(dst draw.Image, src image.Image) {
	sr := src.Bounds()
	dr := dst.Bounds()
	mx := float64(sr.Dx()-1) / float64(dr.Dx())
	my := float64(sr.Dy()-1) / float64(dr.Dy())
	for x := dr.Min.X; x < dr.Max.X; x++ {
		for y := dr.Min.Y; y < dr.Max.Y; y++ {
			gx, tx := math.Modf(float64(x) * mx)
			gy, ty := math.Modf(float64(y) * my)
			srcX, srcY := int(gx), int(gy)
			r00, g00, b00, a00 := src.At(srcX, srcY).RGBA()
			r10, g10, b10, a10 := src.At(srcX+1, srcY).RGBA()
			r01, g01, b01, a01 := src.At(srcX, srcY+1).RGBA()
			r11, g11, b11, a11 := src.At(srcX+1, srcY+1).RGBA()
			result := color.RGBA64{
				R: blerp(r00, r10, r01, r11, tx, ty),
				G: blerp(g00, g10, g01, g11, tx, ty),
				B: blerp(b00, b10, b01, b11, tx, ty),
				A: blerp(a00, a10, a01, a11, tx, ty),
			}
			dst.Set(x, y, result)
		}
	}
}

func lerp(s, e, t float64) float64 { return s + (e-s)*t }
func blerp(c00, c10, c01, c11 uint32, tx, ty float64) uint16 {
	return uint16(lerp(
		lerp(float64(c00), float64(c10), tx),
		lerp(float64(c01), float64(c11), tx),
		ty,
	))
}

func main() {
	src, err := readImage("Lenna100.jpg")
	if err != nil {
		log.Fatal(err)
	}
	sr := src.Bounds()
	dr := image.Rect(0, 0, sr.Dx()*16/10, sr.Dy()*16/10)
	dst := image.NewRGBA(dr)

	// Using the above bilinear interpolation code:
	scale(dst, src)
	err = writeJPEG(dst, "Lenna100_larger.jpg")
	if err != nil {
		log.Fatal(err)
	}

	// Using the golang.org/x/image/draw package
	// (which also provides other iterpolators).
	draw.BiLinear.Scale(dst, dr, src, sr, draw.Src, nil)
	err = writeJPEG(dst, "Lenna100_larger.draw.jpg")
	if err != nil {
		log.Fatal(err)
	}
}

func readImage(filename string) (image.Image, error) {
	f, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer f.Close() // nolint: errcheck
	m, _, err := image.Decode(f)
	return m, err
}

func writeJPEG(m image.Image, filename string) error {
	f, err := os.Create(filename)
	if err != nil {
		return err
	}
	err = jpeg.Encode(f, m, nil)
	if cerr := f.Close(); err == nil {
		err = cerr
	}
	return err
}
