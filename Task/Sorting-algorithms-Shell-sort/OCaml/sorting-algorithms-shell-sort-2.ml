let () =
  let arraysize = 1000 in  (* or whatever *)
  Random.self_init();
  let intArray =
    Array.init arraysize (fun _ -> Random.int 4000)
  in
  shellsort intArray;
  Array.iter (Printf.printf " %d") intArray;
  print_newline();
;;
