let rec digit_sum b n =
  if n < b then n else digit_sum b (n / b) + n mod b

let digital_root b n =
  let rec loop a x =
    if x < b then a, x else loop (succ a) (digit_sum b x)
  in
  loop 0 n

let () =
  let pr_fmt n (p, r) =
    Printf.printf "%u: additive persistence = %u, digital root = %u\n" n p r
  in
  List.iter
    (fun n -> pr_fmt n (digital_root 10 n))
    [627615; 39390; 588225; 393900588225]
