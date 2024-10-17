(* range operator *)
let rec (--) a b =
  if a > b then
    []
  else
    a :: (a+1) -- b

let perf n = n = List.fold_left (+) 0 (List.filter (fun i -> n mod i = 0) (1 -- (n-1)))
