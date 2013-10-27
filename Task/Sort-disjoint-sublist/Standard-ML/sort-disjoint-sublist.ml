functor SortDisjointFn (A : MONO_ARRAY) : sig
    val sort : (A.elem * A.elem -> order) -> (A.array * int array) -> unit
  end = struct

    structure DisjointView : MONO_ARRAY = struct
      type elem = A.elem
      type array = A.array * int array
      fun length (a, s) = Array.length s
      fun sub ((a, s), i) = A.sub (a, Array.sub (s, i))
      fun update ((a, s), i, x) = A.update (a, Array.sub (s, i), x)

      (* dummy implementations for not-needed functions *)
      type vector = unit
      val maxLen = Array.maxLen
      fun array _ = raise Domain
      fun fromList _ = raise Domain
      fun tabulate _ = raise Domain
      fun vector _ = raise Domain
      fun copy _ = raise Domain
      fun copyVec _ = raise Domain
      fun appi _ = raise Domain
      fun app _ = raise Domain
      fun modifyi _ = raise Domain
      fun modify _ = raise Domain
      fun foldli _ = raise Domain
      fun foldl _ = raise Domain
      fun foldri _ = raise Domain
      fun foldr _ = raise Domain
      fun findi _ = raise Domain
      fun find _ = raise Domain
      fun exists _ = raise Domain
      fun all _ = raise Domain
      fun collate _ = raise Domain
    end

    structure DisjointViewSort = ArrayQSortFn (DisjointView)

    fun sort cmp (arr, indices) = (
      ArrayQSort.sort Int.compare indices;
      DisjointViewSort.sort cmp (arr, indices)
    )
  end
