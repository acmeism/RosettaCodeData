let l = fun x () -> x
let _ =
  assert (a 10 (l 1) (l ~-1) (l ~-1) (l 1) (l 0) = -67);
  assert (a 20 (l 1) (l ~-1) (l ~-1) (l 1) (l 0) = -175_416);
  print_endline "passed"
