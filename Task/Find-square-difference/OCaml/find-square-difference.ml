let calculate x =
  succ (succ x lsr 1)

let () =
  Printf.printf "%u\n" (calculate 1000)
