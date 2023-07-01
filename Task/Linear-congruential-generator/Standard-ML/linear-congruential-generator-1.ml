local
  open Word32
in
  fun bsdLcg (seed : int) : int =
    toInt (andb (0w1103515245 * fromInt seed + 0w12345, 0wx7fffffff))
  fun mscLcg (seed : word) : int * word =
    let
      val state = andb (0w214013 * seed + 0w2531011, 0wx7fffffff)
    in
      (toInt (>> (state, 0w16)), state)
    end
end
