package main

import (
  "fmt"
  "strings"
)

func gospers_hack(x int) int {
  c := x & -x
  r := x + c

  return int(float64((r^x)>>2)/float64(c)) | r
}

func main() {
  for _, start := range []int{1, 3, 7, 15} {
    x := start
    results := make([]string, 0, 10)

    for range 10 {
      x = gospers_hack(x)
      results = append(results, fmt.Sprintf("%d", x))
    }

    fmt.Printf("%d: %s\n", start, strings.Join(results, " "))
  }
}
