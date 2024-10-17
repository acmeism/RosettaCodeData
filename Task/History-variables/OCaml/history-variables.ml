open Stack
(* The following line is only for convenience when typing code *)
module H = Stack

let show_entry e =
    Printf.printf "History entry: %5d\n" e

let () =
  let  hs = H.create() in
  H.push 111 hs ;
  H.push 4 hs ;
  H.push 42 hs ;
  H.iter show_entry hs;
  hs |> H.pop |> Printf.printf "%d\n";
  hs |> H.pop |> Printf.printf "%d\n";
  hs |> H.pop |> Printf.printf "%d\n"
