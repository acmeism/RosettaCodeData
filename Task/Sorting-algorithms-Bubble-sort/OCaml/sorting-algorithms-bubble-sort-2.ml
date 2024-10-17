let rec bsort s =
  let rec _bsort = function
    | x :: x2 :: xs when x > x2 -> begin
        match _bsort (x :: xs) with
          | None -> Some (x2 :: x :: xs)
          | Some xs2 -> Some (x2 :: xs2)
      end
    | x :: x2 :: xs -> begin
        match _bsort (x2 :: xs) with
          | None -> None
          | Some xs2 -> Some (x :: xs2)
      end
    | _ -> None
  in
    match _bsort s with
      | None -> s
      | Some s2 -> bsort s2
