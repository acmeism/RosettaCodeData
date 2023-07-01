(*
A solution I'd show to Euclid !!!!.
Nigel Galloway May 4th., 2017
*)
let solve n =
  let (n,_)::(i,e)::g = n|>List.sortBy(fun n->(-(snd n)))
  let rec fn i g e l =
    match e with
    | (n,e)::t when n < i -> fn n g t (l+(i-n-1)*e)
    | (n,e)::t when n > g -> fn i n t (l+(n-g-1)*e)
    | (n,t)::e            -> fn i g e (l-t)
    | _                   -> l
  fn (min n i) (max n i) g (e*(abs(n-i)-1))
