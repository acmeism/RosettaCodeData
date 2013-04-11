package main

import "fmt"
import "math/cmplx"

func mandelbrot(a complex128) (z complex128) {
    for i := 0; i < 50; i++ {
        z = z*z + a
    }
    return
}

func main() {
    for y := 1.0; y >= -1.0; y -= 0.05 {
        for x := -2.0; x <= 0.5; x += 0.0315 {
            if cmplx.Abs(mandelbrot(complex(x, y))) < 2 {
                fmt.Print("*")
            } else {
                fmt.Print(" ")
            }
        }
        fmt.Println("")
    }
}
