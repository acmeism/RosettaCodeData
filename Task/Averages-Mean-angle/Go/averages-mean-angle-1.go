package main

import (
  "fmt"
  "math"
  "math/cmplx"
)

func deg2rad(d float64) float64 { return d * math.Pi / 180 }
func rad2deg(r float64) float64 { return r * 180 / math.Pi }

func mean_angle(deg []float64) float64 {
  sum := 0i
  for _, x := range deg { sum += cmplx.Rect(1, deg2rad(x)) }
  return rad2deg(cmplx.Phase(sum))
}

func main() {
  for _, angles := range [][]float64 {{350, 10}, {90, 180, 270, 360}, {10, 20, 30}} {
    fmt.Printf("The mean angle of %v is: %f degrees\n", angles, mean_angle(angles))
  }
}
