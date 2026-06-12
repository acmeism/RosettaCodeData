let make13 n =
  truncate (10. ** float n) / 9 * 10 + 3

let () =
  for n = 0 to 7 do
    let x = make13 n in Printf.printf "%9u%16u\n" x (x * x)
  done
