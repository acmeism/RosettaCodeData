let dot = List.fold_left2 (fun z x y -> z +. x *. y) 0.

(*
# dot [1.0; 3.0; -5.0] [4.0; -2.0; -1.0];;
- : float = 3.
*)
