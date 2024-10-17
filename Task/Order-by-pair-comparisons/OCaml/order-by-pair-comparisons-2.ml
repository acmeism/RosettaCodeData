let () =
  let count = ref 0 in
  let mycmp s1 s2 = (
    incr count;
    Printf.printf "(%d) Is %s <, ==, or > %s? Answer -1, 0, or 1: " (!count) s1 s2;
    read_int ()
  ) in
  let items = [|"violet"; "red"; "green"; "indigo"; "blue"; "yellow"; "orange"|] in
  Array.sort mycmp items;
  Array.iter (Printf.printf "%s ") items;
  print_newline ()
