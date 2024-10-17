let rec bsort s =
  let rec _bsort = function
    | x :: x2 :: xs when x > x2 ->
        x2 :: _bsort (x :: xs)
    | x :: x2 :: xs ->
        x :: _bsort (x2 :: xs)
    | s -> s
  in
  let t = _bsort s in
    if t = s then t
    else bsort t
