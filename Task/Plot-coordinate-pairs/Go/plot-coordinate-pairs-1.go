package main

import (
  "fmt"
  "log"
  "os/exec"
)

var (
  x = []int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
  y = []float64{2.7, 2.8, 31.4, 38.1, 58.0, 76.2, 100.5, 130.0, 149.3, 180.0}
)

func main() {
  g := exec.Command("gnuplot", "-persist")
  w, err := g.StdinPipe()
  if err != nil {
    log.Fatal(err)
  }
  if err = g.Start(); err != nil {
    log.Fatal(err)
  }
  fmt.Fprintln(w, "unset key; plot '-'")
  for i, xi := range x {
    fmt.Fprintf(w, "%d %f\n", xi, y[i])
  }
  fmt.Fprintln(w, "e")
  w.Close()
  g.Wait()
}
