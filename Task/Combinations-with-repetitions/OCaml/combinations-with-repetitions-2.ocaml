let combs_with_rep m xs =
  let arr = Array.make (m+1) [] in
  arr.(0) <- [[]];
  List.iter (fun x ->
    for i = 1 to m do
      arr.(i) <- arr.(i) @ List.map (fun xs -> x::xs) arr.(i-1)
    done
  ) xs;
  arr.(m)
