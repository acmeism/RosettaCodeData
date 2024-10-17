let tonelli n p =
  let open Z in
  let two = ~$2 in
  let pp = pred p in
  let pph = pred p / two in
  let pow_mod_p a e = powm a e p in
  let legendre_p a = pow_mod_p a pph in

  if legendre_p n <> one then None
  else
    let s = trailing_zeros pp in
    if s = 1 then
      let r = pow_mod_p n (succ p / ~$4) in
      Some (r, p - r)
    else
      let q = pp asr s in
      let z =
        let rec find_non_square z =
          if legendre_p z = pp then z else find_non_square (succ z)
        in
        find_non_square two
      in
      let rec loop c r t m =
        if t = one then (r, p - r)
        else
          let mp = pred m in
          let rec find_i n i =
            if n = one || i >= mp then i else find_i (n * n mod p) (succ i)
          in
          let rec exp_pow2 b e =
            if e <= zero then b else exp_pow2 (b * b mod p) (pred e)
          in
          let i = find_i t zero in
          let b = exp_pow2 c (mp - i) in
          let c = b * b mod p in
          loop c (r * b mod p) (t * c mod p) i
      in
      Some
        (loop (pow_mod_p z q) (pow_mod_p n (succ q / two)) (pow_mod_p n q) ~$s)

let () =
  let open Z in
  [
    (~$9, ~$11);
    (~$10, ~$13);
    (~$56, ~$101);
    (~$1030, ~$10009);
    (~$1032, ~$10009);
    (~$44402, ~$100049);
    (~$665820697, ~$1000000009);
    (~$881398088036, ~$1000000000039);
    ( of_string "41660815127637347468140745042827704103445750172002",
      pow ~$10 50 + ~$577 );
  ]
  |> List.iter (fun (n, p) ->
         Printf.printf "n = %s\np = %s\n%!" (to_string n) (to_string p);
         match tonelli n p with
         | Some (r1, r2) ->
             Printf.printf "root1 = %s\nroot2 = %s\n\n%!" (to_string r1)
               (to_string r2)
         | None -> print_endline "No solution exists\n")
