(*
 * val combine_lists : string list list -> string list
 *)
fun combine_lists nil = nil
|   combine_lists (l1::ls) = List.foldl (ListPair.map (fn (x,y) => y ^
 x)) l1 ls;

(* ["a1Ax","b2By","c3Cz"] *)
combine_lists[["a","b","c"],["1","2","3"],["A","B","C"],["x","y","z"]];
