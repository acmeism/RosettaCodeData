let rec isqrt n =
  if n = 1 then 1
  else let _n = isqrt (n - 1) in
    (_n + (n / _n)) / 2

let sum_divs n =
  let sum = ref 1 in
  for d = 2 to isqrt n do
    if (n mod d) = 0 then sum := !sum + (n / d + d);
  done;
  !sum

let () =
  for n = 2 to 20000 do
    let m = sum_divs n in
    if (m > n) then
      if (sum_divs m) = n then Printf.printf "%d %d\n" n m;
  done
