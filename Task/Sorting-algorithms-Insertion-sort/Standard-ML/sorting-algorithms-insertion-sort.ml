fun insertion_sort cmp = let
  fun insert (x, []) = [x]
    | insert (x, y::ys) =
       case cmp (x, y) of GREATER => y :: insert (x, ys)
                        | _       => x :: y :: ys
in
 foldl insert []
end;

insertion_sort Int.compare [6,8,5,9,3,2,1,4,7];
