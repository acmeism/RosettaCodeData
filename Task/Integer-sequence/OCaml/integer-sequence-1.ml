let () =
  let i = ref 0 in
  while true do
    print_int !i;
    print_newline ();
    incr i;
  done
