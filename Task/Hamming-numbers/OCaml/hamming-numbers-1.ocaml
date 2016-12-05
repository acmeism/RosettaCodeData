module ISet = Set.Make(struct type t = int let compare=compare end)

let pq = ref (ISet.singleton 1)

let next () =
  let m = ISet.min_elt !pq in
  pq := ISet.(remove m !pq  |> add (2*m) |> add (3*m) |> add (5*m));
  m

let () =

  print_string "The first 20 are: ";

  for i = 1 to 20
  do
    Printf.printf "%d " (next ())
  done;

  for i = 21 to 1690
  do
    ignore (next ())
  done;

  Printf.printf "\nThe 1691st is %d\n" (next ());
