package main

import (
  "fmt"
  "strings"
)

func main() {
  var s strings.Builder
  s.WriteString("foo")
  s.WriteString("bar")
  fmt.Print(s.String())
}
