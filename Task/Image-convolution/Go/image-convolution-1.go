package main

import (
    "fmt"
    "image"
    "image/color"
    "image/jpeg"
    "math"
    "os"
)

// kf3 is a generic convolution 3x3 kernel filter that operatates on
// images of type image.Gray from the Go standard image library.
func kf3(k *[9]float64, src, dst *image.Gray) {
    for y := src.Rect.Min.Y; y < src.Rect.Max.Y; y++ {
        for x := src.Rect.Min.X; x < src.Rect.Max.X; x++ {
            var sum float64
            var i int
            for yo := y - 1; yo <= y+1; yo++ {
                for xo := x - 1; xo <= x+1; xo++ {
                    if (image.Point{xo, yo}).In(src.Rect) {
                        sum += k[i] * float64(src.At(xo, yo).(color.Gray).Y)
                    } else {
                        sum += k[i] * float64(src.At(x, y).(color.Gray).Y)
                    }
                    i++
                }
            }
            dst.SetGray(x, y,
                color.Gray{uint8(math.Min(255, math.Max(0, sum)))})
        }
    }
}

var blur = [9]float64{
    1. / 9, 1. / 9, 1. / 9,
    1. / 9, 1. / 9, 1. / 9,
    1. / 9, 1. / 9, 1. / 9}

// blurY example function applies blur kernel to Y channel
// of YCbCr image using generic kernel filter function kf3
func blurY(src *image.YCbCr) *image.YCbCr {
    dst := *src

    // catch zero-size image here
    if src.Rect.Max.X == src.Rect.Min.X || src.Rect.Max.Y == src.Rect.Min.Y {
        return &dst
    }

    // pass Y channels as gray images
    srcGray := image.Gray{src.Y, src.YStride, src.Rect}
    dstGray := srcGray
    dstGray.Pix = make([]uint8, len(src.Y))
    kf3(&blur, &srcGray, &dstGray) // call generic convolution function

    // complete result
    dst.Y = dstGray.Pix                   // convolution result
    dst.Cb = append([]uint8{}, src.Cb...) // Cb, Cr are just copied
    dst.Cr = append([]uint8{}, src.Cr...)
    return &dst
}

func main() {
    // Example file used here is Lenna100.jpg from the task "Percentage
    // difference between images"
    f, err := os.Open("Lenna100.jpg")
    if err != nil {
        fmt.Println(err)
        return
    }
    img, err := jpeg.Decode(f)
    if err != nil {
        fmt.Println(err)
        return
    }
    f.Close()
    y, ok := img.(*image.YCbCr)
    if !ok {
        fmt.Println("expected color jpeg")
        return
    }
    f, err = os.Create("blur.jpg")
    if err != nil {
        fmt.Println(err)
        return
    }
    err = jpeg.Encode(f, blurY(y), &jpeg.Options{90})
    if err != nil {
        fmt.Println(err)
    }
}
