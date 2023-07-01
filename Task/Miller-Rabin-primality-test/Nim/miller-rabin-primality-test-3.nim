(* Translated from the wikipedia pseudo-code *)
let miller_rabin n ~iter:k =
  (* return r and d where n = 2^r*d (from scheme implementation) *)
  let get_rd n =
    let rec loop r d =
      (* not even *)
      if Z.(equal (logand d one) one) then
        (r,d)
      else
        loop Z.(r + one) Z.(div d ~$2)
    in
    loop Z.zero n
  in
  let single_miller n r d =
    (* (random (n - 4)) + 2  *)
    let a = Bigint.to_zarith_bigint
              Bigint.((random ((of_zarith_bigint n) - (of_int 4))) + (of_int 2))
    in
    let x = Z.(powm a d n) in
    if Z.(equal x ~$1) || Z.(equal x (n - ~$1)) then true
    else
      let rec loop i x =
        if Z.(equal ~$i (r - ~$1)) then false
        else
          let x = Z.(powm x ~$2 n) in
          if Z.(equal x (n - ~$1)) then true
          else loop (i + 1) x
      in
      loop 0 x
  in
  let n = Z.abs n in
  if Z.(equal n one) then false
  else if Z.(equal (logand n one) zero) then false
  else if Z.(equal (n mod ~$3) zero) then false
  else
    let r, d = get_rd Z.(n - one) in
    let rec loop i bool =
      if i = k then bool
      else loop (i + 1) (bool && single_miller n r d)
    in
    loop 0 true
