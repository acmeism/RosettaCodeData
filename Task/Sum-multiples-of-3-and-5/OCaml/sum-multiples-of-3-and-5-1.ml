let sum_m3m5 n =
  let termial x = (x * x + x) lsr 1 in
  3 * (termial (n / 3) - 5 * termial (n / 15)) + 5 * termial (n / 5)

let () =
  let pow10 x = truncate (10. ** (float x)) in
  for i = 1 to 9 do
    let u = pred (pow10 i) in
    Printf.printf "Summing multiples of 3 or 5 in 1..%u: %u\n" u (sum_m3m5 u)
  done
