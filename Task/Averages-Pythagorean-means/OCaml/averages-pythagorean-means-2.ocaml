let means v =
  let (a, b, c) =
    Array.fold_left
      (fun (a, b, c) x -> (a+.x, b*.x, c+.1./.x))
      (0.,1.,0.) v
  in
  let n = float_of_int (Array.length v) in
  (a /. n, b ** (1./.n), n /. c)
;;
