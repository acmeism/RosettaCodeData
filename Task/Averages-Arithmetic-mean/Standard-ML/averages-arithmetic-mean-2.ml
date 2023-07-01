fun mean_reals [] = raise Empty
  | mean_reals xs = let
    val (total, length) =
      foldl
        (fn (x, (tot,len)) => (x + tot, len + 1.0))
        (0.0, 0.0) xs
    in
      (total / length)
    end;


fun mean_ints [] = raise Empty
  | mean_ints xs = let
    val (total, length) =
      foldl
        (fn (x, (tot,len)) => (x + tot, len + 1.0))
        (0, 0.0) xs
    in
      (real total / length)
    end;
