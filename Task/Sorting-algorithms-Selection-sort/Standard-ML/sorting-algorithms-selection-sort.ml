fun selection_sort [] = []
  | selection_sort (first::lst) =
    let
      val (small, output) = foldl
        (fn (x, (small, output)) =>
            if x < small then
              (x, small::output)
            else
              (small, x::output)
        ) (first, []) lst
    in
      small :: selection_sort output
    end
