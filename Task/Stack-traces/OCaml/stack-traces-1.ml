let div a b = a / b

let () =
  try let _ = div 3 0 in ()
  with e ->
    prerr_endline(Printexc.to_string e);
    Printexc.print_backtrace stderr;
;;
