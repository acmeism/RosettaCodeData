package main

import "core:slice"
import "core:fmt"

main :: proc() {
  hay_stack := []string{"Zig","Zag","Wally","Ronald","Bush","Krusty","Charlie","Bush","Bozo"}

  // Odin does not support exceptions.
  // For conditions requiring special processing during the execution of a program it is
  // encouraged to make that explicit through return values:

  index, found := slice.linear_search(hay_stack, "Bush")
  if found do fmt.printf("First occurence of 'Bush' at %d\n", index)

  index, found = slice.linear_search(hay_stack, "Rob")
  if found do fmt.printf("First occurence of 'Rob' at %d\n", index)
}

// Output:
// First occurence of 'Bush' at 4
