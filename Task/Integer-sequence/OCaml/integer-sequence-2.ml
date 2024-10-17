let () =
  let rec aux i =
    print_int i;
    print_newline ();
    aux (succ i)
  in
  aux 0
