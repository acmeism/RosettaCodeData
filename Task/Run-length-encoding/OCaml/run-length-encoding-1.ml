let encode str =
  let len = String.length str in
  let rec aux i acc =
    if i >= len then List.rev acc
    else
      let c1 = str.[i] in
      let rec aux2 j =
        if j >= len then (c1, j-i)
        else
          let c2 = str.[j] in
          if c1 = c2
          then aux2 (j+1)
          else (c1, j-i)
      in
      let (c,n) as t = aux2 (i+1) in
      aux (i+n) (t::acc)
  in
  aux 0 []
;;

let decode lst =
  let l = List.map (fun (c,n) -> String.make n c) lst in
  (String.concat "" l)
