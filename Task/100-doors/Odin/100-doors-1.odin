package main

import "core:fmt"

main :: proc() {
 using fmt

  Door_State :: enum {Closed, Open}

  doors := [?]Door_State { 0..<100 = .Closed }

  for i in  1..=100 {
    for j := i-1; j < 100; j += i {
      if doors[j] == .Closed {
        doors[j] = .Open
      } else {
        doors[j] = .Closed
      }
    }
  }
  for state, i in doors {
    println("Door: ",int(i+1)," -> ",state)
  }
}
