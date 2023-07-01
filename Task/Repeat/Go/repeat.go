package main

import "fmt"

func repeat(n int, f func()) {
  for i := 0; i < n; i++ {
    f()
  }
}

func fn() {
  fmt.Println("Example")
}

func main() {
  repeat(4, fn)
}
