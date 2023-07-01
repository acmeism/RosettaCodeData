let map_range (a1, a2) (b1, b2) =
  let v = (b2 -. b1) /. (a2 -. a1) in
  function s ->
    b1 +. ((s -. a1) *. v)

let () =
  print_endline "Mapping [0,10] to [-1,0] at intervals of 1:";
  let p = (map_range (0.0, 10.0) (-1.0, 0.0)) in
  for i = 0 to 10 do
    Printf.printf "f(%d) = %g\n" i (p (float i))
  done
