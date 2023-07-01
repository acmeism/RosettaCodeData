let () =
  let e = encode "aaaaahhhhhhmmmmmmmuiiiiiiiaaaaaa" in
  List.iter (fun (c,n) ->
    Printf.printf " (%c, %d);\n" c n;
  ) e;
  print_endline (decode [('a', 5); ('h', 6); ('m', 7); ('u', 1); ('i', 7); ('a', 6)]);
;;
