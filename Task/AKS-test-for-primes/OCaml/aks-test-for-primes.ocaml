#require "gen"
#require "zarith"
open Z
let range ?(step=one) i j = if i = j then Gen.empty else Gen.unfold (fun k ->
    if compare i j = compare k j then Some (k, (add step k)) else None) i

(* kth coefficient of (x - 1)^n *)
let coeff n k =
  let numer = Gen.fold mul one
    (range n (sub n k) ~step:minus_one) in
  let denom = Gen.fold mul one
    (range k zero ~step:minus_one) in
  div numer denom |> mul @@
    if
      compare k n < 0 && is_even k
    then
      minus_one
    else
      one

(* coefficient series for (x - 1)^n, k=[0..n] *)
let coeff_series n =
  Gen.map (coeff n) (range zero (succ n))

let middle g = Gen.drop 1 g |> Gen.peek |> Gen.filter_map
  (function (_, None) -> None | (e, _) -> Some e)

let is_mod_p ~p n = rem n p = zero

let aks p =
  coeff_series p |> middle |> Gen.for_all (is_mod_p ~p)

let _ =
  print_endline "coefficient series n (k[0] .. k[n])";
  Gen.iter
    (fun n -> Format.printf "%d (%s)\n" (to_int n)
      (Gen.map to_string (coeff_series n) |> Gen.to_list |> String.concat " "))
    (range zero (of_int 10));
  print_endline "";
  print_endline ("primes < 50 per AKS: " ^
    (Gen.filter aks (range (of_int 2) (of_int 50)) |>
    Gen.map to_string |> Gen.to_list |> String.concat " "))
