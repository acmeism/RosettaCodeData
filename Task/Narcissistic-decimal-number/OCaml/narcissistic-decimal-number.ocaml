let narcissistic =
  let rec next n l p () =
    let rec digit_pow_sum a n =
      if n < 10 then a + p.(n) else digit_pow_sum (a + p.(n mod 10)) (n / 10)
    in
    if n = l then next n (l * 10) (Array.mapi ( * ) p) ()
    else if n = digit_pow_sum 0 n then Seq.Cons (n, next (succ n) l p)
    else next (succ n) l p ()
  in
  next 0 10 (Array.init 10 Fun.id)

let () =
  narcissistic |> Seq.take 25 |> Seq.iter (Printf.printf " %u") |> print_newline
