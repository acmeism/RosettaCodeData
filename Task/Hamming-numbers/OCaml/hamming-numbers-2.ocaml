open Big_int

module APSet = Set.Make(
  struct
    type t = big_int
    let compare = compare_big_int
  end)

let pq = ref (APSet.singleton (big_int_of_int 1))

let next () =
  let m = APSet.min_elt !pq in
  let ( * ) = mult_int_big_int in
  pq := APSet.(remove m !pq  |> add (2*m) |> add (3*m) |> add (5*m));
  m

let () =
  let n = 1_000_000 in

  for i = 1 to (n-1)
  do
    ignore (next ())
  done;

  Printf.printf "\nThe %dth is %s\n" n (string_of_big_int (next ()));
