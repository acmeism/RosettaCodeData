let meaning_of_life = 42

let main () =
  Printf.printf "Main: The meaning of life is %d\n"
    meaning_of_life

let () =
  if not !Sys.interactive then
    main ()
