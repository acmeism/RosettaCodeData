let () =
  n_arrays_iter [a1; a2; a3] ~f:(fun l ->
    List.iter print_char l;
    print_newline());
;;
