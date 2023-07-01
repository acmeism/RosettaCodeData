fun fence s [] =
      if s >= 3 then
        [[]]
      else
        []

  | fence s (x :: xs) =
      if s mod 2 = 0 then
        map
          (fn ys => x :: ys)
          (fence (s + 1) xs)
        @
          fence s xs
      else
        map
          (fn ys => x :: ys)
          (fence s xs)
        @
          fence (s + 1) xs

fun ncsubseq xs = fence 0 xs
