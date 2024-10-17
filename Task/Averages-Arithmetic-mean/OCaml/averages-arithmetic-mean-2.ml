let mean_floats xs =
  if xs = [] then
    invalid_arg "empty list"
  else
    let total, length =
      List.fold_left
        (fun (tot,len) x -> (x +. tot), len +. 1.)
        (0., 0.) xs
    in
    (total /. length)
;;


let mean_ints xs =
  if xs = [] then
    invalid_arg "empty list"
  else
    let total, length =
      List.fold_left
        (fun (tot,len) x -> (x + tot), len +. 1.)
        (0, 0.) xs
    in
    (float total /. length)
;;
