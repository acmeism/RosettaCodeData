fun lis cmp n =
  let
    val pile_tops = DynamicArray.array (length n, [])
    fun bsearch_piles x =
      let
        fun aux (lo, hi) =
          if lo > hi then
            lo
          else
            let
              val mid = (lo + hi) div 2
            in
              if cmp (hd (DynamicArray.sub (pile_tops, mid)), x) = LESS then
                aux (mid+1, hi)
              else
                aux (lo, mid-1)
            end
      in
        aux (0, DynamicArray.bound pile_tops)
      end
    fun f x =
      let
        val i = bsearch_piles x
      in
        DynamicArray.update (pile_tops, i,
	  x :: (if i = 0 then [] else DynamicArray.sub (pile_tops, i-1)))
      end
  in
    app f n;
    rev (DynamicArray.sub (pile_tops, DynamicArray.bound pile_tops))
  end
