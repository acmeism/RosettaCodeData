fun quickselect (_, _, []) = raise Fail "empty"
  | quickselect (k, cmp, x :: xs) = let
        val (ys, zs) = List.partition (fn y => cmp (y, x) = LESS) xs
        val l = length ys
      in
        if k < l then
          quickselect (k, cmp, ys)
        else if k > l then
          quickselect (k-l-1, cmp, zs)
        else
          x
      end
