let rec combs_with_rep k xxs =
  match k, xxs with
  | 0,  _ -> [[]]
  | _, [] -> []
  | k, x::xs ->
      List.map (fun ys -> x::ys) (combs_with_rep (k-1) xxs)
      @ combs_with_rep k xs
