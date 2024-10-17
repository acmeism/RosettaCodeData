let dot v u =
  if Array.length v <> Array.length u
  then invalid_arg "Different array lengths";
  let times v u =
    Array.mapi (fun i v_i -> v_i *. u.(i)) v
  in Array.fold_left (+.) 0. (times v u)

(*
# dot [| 1.0; 3.0; -5.0 |] [| 4.0; -2.0; -1.0 |];;
- : float = 3.
*)
