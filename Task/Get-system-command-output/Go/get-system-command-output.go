package main

import (
  "fmt"
  "log"
  "os/exec"
)

func main() {
  output, err := exec.Command("ls", "-l").CombinedOutput()
  if err != nil {
    log.Fatal(err)
  }
  fmt.Print(string(output))
}
