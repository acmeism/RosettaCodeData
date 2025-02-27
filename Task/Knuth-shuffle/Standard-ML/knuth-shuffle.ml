val rng = ref (SplitMix64.init NONE)

fun getRandInt max =
  let
    val (rng', next) = SplitMix64.nextRange (0, max)
    val () = rng := rng'
  in
    Word64.toInt next
  end

fun knuthShuffle a =
  let
    val i = ref ((Array.length a) - 1)
  in
    while !i > 0 do
      let
        val a_i = Array.sub (a, !i)
        val j = getRandInt !i
        val a_j = Array.sub (a, j)
      in
        (Array.update (a, !i, a_j); Array.update (a, j, a_i); i := (!i - 1))
      end
  end
