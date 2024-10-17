let repeat ~f ~n =
  for i = 1 to n do
    f ()
  done

let func () =
  print_endline "Example"

let () =
  repeat ~n:4 ~f:func
