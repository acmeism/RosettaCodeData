let rot13_str s =
  let len = String.length s in
  let result = String.create len in
  for i = 0 to len - 1 do
    result.[i] <- rot13 s.[i]
  done;
  result

(* or in OCaml 4.00+:
   let rot13_str = String.map rot13
*)
