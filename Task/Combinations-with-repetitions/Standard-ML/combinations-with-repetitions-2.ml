fun combs_with_rep (m, xs) = let
  val arr = Array.array (m+1, [])
in
  Array.update (arr, 0, [[]]);
  app (fn x =>
    Array.modifyi (fn (i, y) =>
      if i = 0 then y else y @ map (fn xs => x::xs) (Array.sub (arr, i-1))
    ) arr
  ) xs;
  Array.sub (arr, m)
end
