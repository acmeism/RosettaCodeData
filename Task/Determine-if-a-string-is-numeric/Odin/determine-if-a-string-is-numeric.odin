package main

import "core:strconv"
import "core:fmt"

is_numeric :: proc(s: string) -> bool {
  _, ok := strconv.parse_f32(s)
  return ok
}

main :: proc() {
  strings := []string{"1", "3.14", "-100", "1e2", "Inf", "rose"}
  for s in strings {
    fmt.println(s, "is", is_numeric(s) ? "numeric" : "not numeric")
  }
}

/* Output:
1 is numeric
3.14 is numeric
-100 is numeric
1e2 is numeric
Inf is not numeric
rose is not numeric
*/
