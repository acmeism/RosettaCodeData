structure PilePriority = struct
  type priority = int
  fun compare (x, y) = Int.compare (y, x) (* we want min-heap *)
  type item = int list
  val priority = hd
end

structure PQ = LeftPriorityQFn (PilePriority)

fun sort_into_piles n =
  let
    val piles = DynamicArray.array (length n, [])
    fun bsearch_piles x =
      let
        fun aux (lo, hi) =
          if lo > hi then
            lo
          else
            let
              val mid = (lo + hi) div 2
            in
              if hd (DynamicArray.sub (piles, mid)) < x then
                aux (mid+1, hi)
              else
                aux (lo, mid-1)
            end
      in
        aux (0, DynamicArray.bound piles)
      end
    fun f x =
      let
        val i = bsearch_piles x
      in
        DynamicArray.update (piles, i, x :: DynamicArray.sub (piles, i))
      end
  in
    app f n;
    piles
  end

fun merge_piles piles =
  let
    val heap = DynamicArray.foldl PQ.insert PQ.empty piles
    fun f (heap, acc) =
      case PQ.next heap of
        NONE => acc
      | SOME (x::xs, heap') =>
        f ((if null xs then heap' else PQ.insert (xs, heap')),
           x::acc)
  in
    rev (f (heap, []))
  end

fun patience_sort n =
  merge_piles (sort_into_piles n)
