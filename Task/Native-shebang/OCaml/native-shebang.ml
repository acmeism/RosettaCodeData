#! /usr/bin/env ocaml

let () =
  let argl = Array.to_list Sys.argv in
  print_endline (String.concat " " (List.tl argl))
