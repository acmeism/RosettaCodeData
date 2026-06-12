val lcs =
  let
    val commonSuffix = fn (s0, s1) =>
      let
        val rec pairTakeREq = fn (0, _) => s0 | (_, 0) => s1 | (i, j) =>
          let
            val i' = i - 1 and j' = j - 1
          in
            if String.sub (s0, i') = String.sub (s1, j')
            then pairTakeREq (i', j')
            else String.extract (s0, i, NONE)
          end
      in
        pairTakeREq (size s0, size s1)
      end
  in
    fn [] => "" | x :: xs => foldl commonSuffix x xs
  end
