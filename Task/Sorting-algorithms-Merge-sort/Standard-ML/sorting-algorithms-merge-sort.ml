fun merge cmp ([], ys) = ys
  | merge cmp (xs, []) = xs
  | merge cmp (xs as x::xs', ys as y::ys') =
      case cmp (x, y) of GREATER => y :: merge cmp (xs, ys')
                       | _       => x :: merge cmp (xs', ys)
;
fun merge_sort cmp [] = []
  | merge_sort cmp [x] = [x]
  | merge_sort cmp xs = let
      val ys = List.take (xs, length xs div 2)
      val zs = List.drop (xs, length xs div 2)
    in
      merge cmp (merge_sort cmp ys, merge_sort cmp zs)
    end
;
merge_sort Int.compare [8,6,4,2,1,3,5,7,9]
