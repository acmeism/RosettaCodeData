let () =
  Array.iter print_endline (
    Sys.readdir Sys.argv.(1) )
