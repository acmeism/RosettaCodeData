let rec strike_nth k n l = match l with
  | [] -> []
  | h :: t ->
    if k = 0 then 0 :: strike_nth (n-1) n t
    else h :: strike_nth (k-1) n t
(* val strike_nth : int -> int -> int list -> int list *)

let primes n =
  let limit = truncate(sqrt(float n)) in
  let rec range a b = if a > b then [] else a :: range (a+1) b in
  let rec sieve_primes l = match l with
    | [] -> []
    | 0 :: t -> sieve_primes t
    | h :: t -> if h > limit then List.filter ((<) 0) l else
        h :: sieve_primes (strike_nth (h-1) h t) in
  sieve_primes (range 2 n)
(* val primes : int -> int list *)
