let rec fold_pairwise f m = function
  | a :: (b :: _ as t) -> fold_pairwise f (f m a b) t
  | _ -> m

let pair_to_str (a, b) =
  Printf.sprintf "(%g, %g)" a b

let max_diffs =
  let next m a b =
    match abs_float (b -. a), m with
    | d', (d, _) when d' > d -> d', [a, b]
    | d', (d, l) when d' = d -> d', (a, b) :: l
    | _ -> m
  in fold_pairwise next (0., [])

let () =
  let d, l = max_diffs [1.;8.;2.;-3.;0.;1.;1.;-2.3;0.;5.5;8.;6.;2.;9.;11.;10.;3.] in
  List.rev_map pair_to_str l |> String.concat " " |> Printf.printf "%g: %s\n" d
