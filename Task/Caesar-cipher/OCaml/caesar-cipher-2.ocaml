let () =
  let key = 3 in
  let orig = "The five boxing wizards jump quickly" in
  let enciphered = rot key orig in
  print_endline enciphered;
  let deciphered = rot (- key) enciphered in
  print_endline deciphered;
  Printf.printf "equal: %b\n" (orig = deciphered)
;;
