package main

import (
    "github.com/fogleman/gg"
    "math"
)

func main() {
    dc := gg.NewContext(400, 400)
    dc.SetRGB(1, 1, 1)
    dc.Clear()
    dc.SetRGB(0, 0, 1)
    c := (math.Sqrt(5) + 1) / 2
    numberOfSeeds := 3000
    for i := 0; i <= numberOfSeeds; i++ {
        fi := float64(i)
        fn := float64(numberOfSeeds)
        r := math.Pow(fi, c) / fn
        angle := 2 * math.Pi * c * fi
        x := r*math.Sin(angle) + 200
        y := r*math.Cos(angle) + 200
        fi /= fn / 5
        dc.DrawCircle(x, y, fi)
    }
    dc.SetLineWidth(1)
    dc.Stroke()
    dc.SavePNG("sunflower_fractal.png")
}
