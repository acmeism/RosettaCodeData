package main

import (
  "fmt"
  "math"
)

var (
  d1 = []float64{27.5, 21.0, 19.0, 23.6, 17.0, 17.9, 16.9, 20.1, 21.9, 22.6,
    23.1, 19.6, 19.0, 21.7, 21.4}
  d2 = []float64{27.1, 22.0, 20.8, 23.4, 23.4, 23.5, 25.8, 22.0, 24.8, 20.2,
    21.9, 22.1, 22.9, 20.5, 24.4}
  d3 = []float64{17.2, 20.9, 22.6, 18.1, 21.7, 21.4, 23.5, 24.2, 14.7, 21.8}
  d4 = []float64{21.5, 22.8, 21.0, 23.0, 21.6, 23.6, 22.5, 20.7, 23.4, 21.8,
    20.7, 21.7, 21.5, 22.5, 23.6, 21.5, 22.5, 23.5, 21.5, 21.8}
  d5 = []float64{19.8, 20.4, 19.6, 17.8, 18.5, 18.9, 18.3, 18.9, 19.5, 22.0}
  d6 = []float64{28.2, 26.6, 20.1, 23.3, 25.2, 22.1, 17.7, 27.6, 20.6, 13.7,
    23.2, 17.5, 20.6, 18.0, 23.9, 21.6, 24.3, 20.4, 24.0, 13.2}
  d7 = []float64{30.02, 29.99, 30.11, 29.97, 30.01, 29.99}
  d8 = []float64{29.89, 29.93, 29.72, 29.98, 30.02, 29.98}
  x  = []float64{3.0, 4.0, 1.0, 2.1}
  y  = []float64{490.2, 340.0, 433.9}
)

func main() {
  fmt.Printf("%.6f\n", pValue(d1, d2))
  fmt.Printf("%.6f\n", pValue(d3, d4))
  fmt.Printf("%.6f\n", pValue(d5, d6))
  fmt.Printf("%.6f\n", pValue(d7, d8))
  fmt.Printf("%.6f\n", pValue(x, y))
}

func mean(a []float64) float64 {
  sum := 0.
  for _, x := range a {
    sum += x
  }
  return sum / float64(len(a))
}

func sv(a []float64) float64 {
  m := mean(a)
  sum := 0.
  for _, x := range a {
    d := x - m
    sum += d * d
  }
  return sum / float64(len(a)-1)
}

func welch(a, b []float64) float64 {
  return (mean(a) - mean(b)) /
    math.Sqrt(sv(a)/float64(len(a))+sv(b)/float64(len(b)))
}

func dof(a, b []float64) float64 {
  sva := sv(a)
  svb := sv(b)
  n := sva/float64(len(a)) + svb/float64(len(b))
  return n * n /
    (sva*sva/float64(len(a)*len(a)*(len(a)-1)) +
      svb*svb/float64(len(b)*len(b)*(len(b)-1)))
}

func simpson0(n int, upper float64, f func(float64) float64) float64 {
  sum := 0.
  nf := float64(n)
  dx0 := upper / nf
  sum += f(0) * dx0
  sum += f(dx0*.5) * dx0 * 4
  x0 := dx0
  for i := 1; i < n; i++ {
    x1 := float64(i+1) * upper / nf
    xmid := (x0 + x1) * .5
    dx := x1 - x0
    sum += f(x0) * dx * 2
    sum += f(xmid) * dx * 4
    x0 = x1
  }
  return (sum + f(upper)*dx0) / 6
}

func pValue(a, b []float64) float64 {
  ν := dof(a, b)
  t := welch(a, b)
  g1, _ := math.Lgamma(ν / 2)
  g2, _ := math.Lgamma(.5)
  g3, _ := math.Lgamma(ν/2 + .5)
  return simpson0(2000, ν/(t*t+ν),
    func(r float64) float64 { return math.Pow(r, ν/2-1) / math.Sqrt(1-r) }) /
    math.Exp(g1+g2-g3)
}
