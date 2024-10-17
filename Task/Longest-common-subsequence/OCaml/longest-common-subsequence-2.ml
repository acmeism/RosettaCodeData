let lcs xs ys =
  let cache = Hashtbl.create 16 in
  let rec lcs xs ys =
    try Hashtbl.find cache (xs, ys) with
    | Not_found ->
        let result =
          match xs, ys with
          | [], _ -> []
          | _, [] -> []
          | x :: xs, y :: ys when x = y ->
              x :: lcs xs ys
          | _ :: xs_rest, _ :: ys_rest ->
              let a = lcs xs_rest ys in
              let b = lcs xs      ys_rest in
              if (List.length a) > (List.length b) then a else b
        in
        Hashtbl.add cache (xs, ys) result;
        result
  in
  lcs xs ys
