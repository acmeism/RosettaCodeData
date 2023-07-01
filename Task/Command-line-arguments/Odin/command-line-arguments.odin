package main

import "core:os"
import "core:fmt"

main :: proc() {
  fmt.println(os.args)
}

// Run:     ./program -c "alpha beta" -h "gamma"
// Output:  ["./program", "-c", "alpha beta", "-h", "gamma"]
