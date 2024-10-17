let levenshtein s t =
   let rec dist i j = match (i,j) with
      | (i,0) -> i
      | (0,j) -> j
      | (i,j) ->
         if s.[i-1] = t.[j-1] then dist (i-1) (j-1)
         else let d1, d2, d3 = dist (i-1) j, dist i (j-1), dist (i-1) (j-1) in
         1 + min d1 (min d2 d3)
   in
   dist (String.length s) (String.length t)

let test s t =
  Printf.printf " %s -> %s = %d\n" s t (levenshtein s t)

let () =
  test "kitten" "sitting";
  test "rosettacode" "raisethysword";
