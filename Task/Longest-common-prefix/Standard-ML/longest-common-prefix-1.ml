val lcp =
  let
    val longerFirst = fn pair as (a, b) =>
      if size a < size b then (b, a) else pair
    and commonPrefix = fn (l, s) =>
      case CharVector.findi (fn (i, c) => c <> String.sub (l, i)) s of
        SOME (i, _) => String.substring (s, 0, i)
      | _ => s
  in
    fn [] => "" | x :: xs => foldl (commonPrefix o longerFirst) x xs
  end
