let rem_space str =
  let len = String.length str in
  let res = Bytes.create len in
  let rec aux i j =
    if i >= len
    then (Bytes.sub_string res 0 j)
    else match str.[i] with
      | ' ' | '\n' | '\t' | '\r' ->
        aux (i+1) (j)
      | _ ->
        Bytes.set res j str.[i];
        aux (i+1) (j+1)
  in
  aux 0 0
